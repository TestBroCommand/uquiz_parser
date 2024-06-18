import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:uquiz_parser/quiz.dart';
final dio = Dio();
Future<List<String>> getIds() async {
  File _file = File("input.txt");
  List<String> _result = await _file.readAsLines();
  return _result;
}

Future<List<Quiz>> getQuizzes(List<String> ids) async {
  for (int i = 0; i < ids.length; i++) {
    Response _response = await Dio().get("https://uquiz.com/api/quizstatus/$i");
    final _json = jsonDecode(_response.data);
    final int id = _json["QuizVersionId"];
    final int results = _json["TotalQuestionCount"];
    Response _responseHtml = await Dio().get("https://uquiz.com/static/Quiz/qs/$i/$id/1/3");
    //https://img2.uquiz.com/content/images/quiz/763345_1680180659_38a1a3b1-f341-49c5-9e75-fa98d711db55.jpg
    
  }
}

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
      print(e);
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }