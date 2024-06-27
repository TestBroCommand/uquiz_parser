import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:uquiz_parser/uquiz_parser.dart';

class Question {
  final int questionNumber;
  final String questionText;
  final List<String> answers;
  final List<String> answersIds;

  Question(
      {required this.questionNumber,
      required this.answersIds,
      // required this.questionImage,
      required this.questionText,
      required this.answers});

  factory Question.fromJson(
    int questionNumber,
    Map<String, dynamic> json,
  ) {
    final questionHtml = json['QuestionHtml'] ?? '';
    final questionText = _extractQuestionText(questionHtml);
    // final questionImage = _downloadImage(questionHtml);
    final answers = _extractAnswers(questionHtml);
    final answersIds = _extractId(questionHtml)
        .sublist(0, _extractId(questionHtml).length - 1);
    return Question(
      answersIds: answersIds,
      questionNumber: questionNumber,
      //   questionImage: questionImage,
      questionText: questionText,
      answers: answers,
    );
  }

  static List<String> _extractId(String html) {
    
    if (scSite!.statusCode == 200) {
      final quizData = scSite!.data;
      var jsonData = json.decode(quizData);

      List<String> personalityTypeIds = [];

      for (var question in jsonData['ScoreCardQuestions']) {
        for (var answer in question['PersonalityAnswers']) {
          for (var typeId in answer['PersonalityTypeIds']) {
            print(typeId);
            personalityTypeIds.add(typeId.toString());
          }
        }
      }
      return personalityTypeIds;
      /*  final regExp = RegExp(
        r'<input.*?value="(.*?)"',
        dotAll: true,
      );
      final matches = regExp.allMatches(html);
       return matches.map((match) {
        return match.group(1)?.trim() ?? '';
      }).toList();
      */
    }
    return [];
  }

  static String? _downloadImage(String html) {
    final regExp = RegExp(r'<img[^>]+src="([^"]+)"');
    final match = regExp.firstMatch(html);
    return match?.group(1)?.trim();
  }

  static String _extractQuestionText(String html) {
    final regExp = RegExp(r'<div class="question_text">(.*?)<\/div>');
    final match = regExp.firstMatch(html);
    return match?.group(1)?.trim() ?? '';
  }

  static List<String> _extractAnswers(String html) {
    final regExp = RegExp(
        r'<label class="answer_row".*?>.*?<span class="answer_text">(.*?)<\/span>.*?<\/label>',
        dotAll: true);
    final matches = regExp.allMatches(html);
    return matches.map((match) {
      return match.group(1)?.trim() ?? '';
    }).toList();
  }
}
