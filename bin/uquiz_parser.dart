import 'dart:convert';

import 'package:pocketbase/pocketbase.dart';
import 'package:uquiz_parser/final.dart';
import 'package:uquiz_parser/question.dart';
import 'package:uquiz_parser/quiz.dart';
import 'package:uquiz_parser/uquiz_parser.dart' as uquiz_parser;
import 'package:uquiz_parser/uquiz_parser.dart';
import 'package:xml/xml.dart';

final pb = PocketBase('https://pb-dev.testbroapp.ru');
List quizList = [
  "любовь",
];
/*

  "боль",
    "кинны",
  "аура",
  "расставания",
  "душа",
  "отношения",
  "личность",
  "цвет",
  "характер",
  "тип_привязанности",
  "игра",
  "ориентация",
  "депрессия",
  "запах",
  "парень",
  "геншин",
  "вайб",
  "аниме",
  "стиль",
  "хоррор",
  "монстр",
  "мбти",
  "философия",
  "дарама"
*/
String decodeHtmlEntities(String html) {
  var text =
      html.replaceAllMapped(RegExp(r'&#x([a-fA-F0-9]+);'), (Match match) {
    var value = int.parse(match.group(1)!, radix: 16);
    return String.fromCharCode(value);
  });
  return text;
}

void main(List<String> arguments) async {
  final regexYandex = RegExp(r'https://uquiz\.com/quiz/([a-zA-Z0-9]+)');
  await pb.admins.authWithPassword('uohucku3ne@mail.authpass.app',
      "'PIGwYyX@VDw)rM~7feT)VG\$pntQTrhwkLq432ad");
  for (var tag in quizList) {
    List<String> urls = [];
    for (int i = 0; i < 15; i++) {
      final yandexResponse = await dio.get(
          "https://yandex.ru/search/xml?folderid=b1gono9ktmuo5f4r8kk7&apikey=AQVN1rMGe0p4Qxde3twAxtzxELRv0Vn_XXMrMmQ-&query=site:uquiz.com/quiz_$tag&page=$i");
      final yandexData = XmlDocument.parse(yandexResponse.data);
      print(yandexData);
      urls.addAll(yandexData.findAllElements('url').map((element) {
        return regexYandex
            .firstMatch(element.text.toString())!
            .group(1)
            .toString();
      }).toList());
    }
    print(urls);
    List<String> idss = await sendToPocketbase(urls);
    await pb
        .collection('tags_uquiz')
        .create(body: {"name": tag, "quizes": idss});
    urls.clear();
  }
}

Future<List<String>> sendToPocketbase(List<String> ids) async {
  List<Quiz> quizResults = await uquiz_parser.getQuizzes(ids);
  final List finalList = [];
  final List questionList = [];
  final List startList = [];
  List<String> quizTag = [];
  for (Quiz quiz in quizResults) {
    var startId;
    await pb.collection('start_page_uquiz').create(body: {
      "name": quiz.start.name,
      "image": quiz.start.imageUrl,
      "description": quiz.start.description
    }).then((record) {
      startId = record.id;
    });
    for (Final finals in quiz.results) {
      await pb.collection('final_page_uquiz').create(body: {
        "name": finals.name,
        "image": finals.imageUrl,
        "description": finals.description,
        "digit": finals.digit
      }).then((record) {
        finalList.add(record.id);
      });
    }
    for (Question question in quiz.questions) {
      Map<String, dynamic> jsonMap = {};
      String questionStringId = '';
      for (int i = 0; i < question.answers.length; i++) {
        jsonMap[i.toString()] = {
          decodeHtmlEntities(question.answers[i]): question.answersIds[i]
        };
      }
      await pb.collection('quiz_page_uquiz').create(body: {
        "question": decodeHtmlEntities(question.questionText), // Add this line
        "answers": jsonMap
      }).then((record) {
        questionList.add(record.id);
      });
    }
    var quizTwec = await pb.collection('quizes_uquiz').create(body: {
      "name": quiz.home.name,
      "description": quiz.home.description,
      "start_page": startId,
      "final_page": finalList,
      "pages": questionList,
      "image": quiz.home.imageUrl
    });
    print(quizTwec.id);
    quizTag.add(quizTwec.id);
    finalList.clear();
    questionList.clear();
    startList.clear();
  }
  return quizTag;
}
//TODO images pocketbase