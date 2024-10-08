import 'dart:io';
import 'package:dio/dio.dart';
import 'package:uquiz_parser/final.dart';

import 'package:uquiz_parser/home.dart';
import 'package:uquiz_parser/question.dart';
import 'package:uquiz_parser/quiz.dart';
import 'package:uquiz_parser/uquiz_parser.dart';

final dio = Dio();
Future<List<String>> getIds() async {
  File file = File("input.txt");
  List<String> result = await file.readAsLines();
  return result;
}

Response? scSite;
Future<List<Question>> fetchQuestions(
    dynamic quizId, int versionId, int start, int count) async {
  scSite =
      await Dio().get('https://uquiz.com/static/Quiz/sc/$quizId/$versionId');
  List<Question> questions = [];
  Dio dio = Dio();

  try {
    Response response = await dio.get(
        "https://uquiz.com/static/Quiz/qs/$quizId/$versionId/$start/$count");
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = response.data;
      json.forEach((key, value) {
        if (value is Map<String, dynamic>) {
          final questionNumber = int.tryParse(key) ?? 0;
          questions.add(Question.fromJson(questionNumber, value));
        }
      });
    } else {
      print('Error: ${response.statusCode}');
    }
  } catch (e) {
    print('Exception: $e');
  }
  return questions;
}

Future<String> fetchQuizName(String quizId) async {
  Dio dio = Dio();

  try {
    Response response = await dio.get('https://uquiz.com/quiz/embed/hRaAfq');
    List<dynamic> quizzes = response.data;
    for (var quiz in quizzes) {
      if (quiz['QuizUrlId'] == quizId) {
        return quiz['QuizName'];
      }
    }
    return 'Quiz not found';
  } catch (e) {
    print('Exception: $e');
    return 'Error occurred';
  }
}

Future<Home> fetchHome(String quizId) async {
  Dio dio = Dio();
  Response response = await dio.get('https://uquiz.com/quiz/embed/$quizId');
  String html = response.data;
  // print(html);
  Home home = Home.fromJson(html, quizId);
  return home;
}

Future<List<Final>> fetchFinals(String quizId, dynamic versionId) async {
  Dio dio = Dio();
  Response response =
      await dio.get('https://uquiz.com/static/Quiz/sc/$quizId/$versionId');

  if (response.statusCode == 200) {
    final quizData = response.data as Map<String, dynamic>;

    List<Final> finalsPages = [];
    final Set<int> uniquePersonalityTypeIds = {};
    for (var question in quizData['ScoreCardQuestions']) {
      if (question['PersonalityAnswers'] != null) {
        for (var answer in question['PersonalityAnswers']) {
          uniquePersonalityTypeIds
              .addAll(List<int>.from(answer['PersonalityTypeIds']));
        }
      }
    }

    for (var personalityTypeId in uniquePersonalityTypeIds) {
      Response finalResponse = await dio.get(
          'https://uquiz.com/Result/static/lite/$quizId/$versionId/personality/$personalityTypeId');

      if (finalResponse.statusCode == 200) {
        final finalData = finalResponse.data;
        Final finalEntity = Final.fromJson(finalData);
        finalsPages.add(finalEntity);
      }
    }
    return finalsPages;
  } else {
    throw Exception('Failed to load quiz data');
  }
}

Future<List<Quiz>> getQuizzes(List<String> ids) async {
  List<Quiz> allQuizzes = [];
  Dio dio = Dio();

  for (String id in ids) {
    try {
      Response response = await dio.get("https://uquiz.com/api/quizstatus/$id");
      if (response.statusCode == 200) {
        List<Question> currentQuizQuestions = [];
        // String quizName = await fetchQuizName(id);

        final json = response.data as Map<String, dynamic>;
        final int versionId = json["QuizVersionId"];
        final int totalQuestions = json["TotalQuestionCount"];
        int fullSets = totalQuestions ~/ 3;
        int remainder = totalQuestions % 3;

        for (int i = 0; i < fullSets; i++) {
          List<Question> questions =
              await fetchQuestions(id, versionId, i * 3 + 1, 3);
          currentQuizQuestions.addAll(questions);
        }

        if (remainder > 0) {
          List<Question> questions =
              await fetchQuestions(id, versionId, fullSets * 3 + 1, remainder);
          currentQuizQuestions.addAll(questions);
        }
        final Home home = await fetchHome(id);
        final List<Final> finals = await fetchFinals(id, versionId);
        Quiz currentQuiz = Quiz(
          questions: currentQuizQuestions,
          results: finals,
          start: home,
          home: home,
        );

        allQuizzes.add(currentQuiz);
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }
  return allQuizzes;
}

// Response _responseHtml = await Dio().get("https://uquiz.com/static/Quiz/qs/$i/$id/1/3");
//https://img2.uquiz.com/content/images/quiz/763345_1680180659_38a1a3b1-f341-49c5-9e75-fa98d711db55.jpg

Future<void> downloadFile(String url) async {
  try {
    Response response = await dio.get(
      url,
      onReceiveProgress: showDownloadProgress,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
        validateStatus: (status) => status! < 500,
      ),
    );

    File file = File(url);
    var raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(response.data);
    await raf.close();
  } catch (e) {
    //print(e);
  }
}

void showDownloadProgress(received, total) {
  if (total != -1) {
    print((received / total * 100).toStringAsFixed(0) + "%");
  }
}
