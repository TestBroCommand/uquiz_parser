import 'package:uquiz_parser/final.dart';
import 'package:uquiz_parser/home.dart';
import 'package:uquiz_parser/question.dart';

class Quiz {
  final Home start;
  final Home home;
  final List<Question> questions;
  final List<Final> results;

  Quiz({
    required this.questions,
    required this.results,
    required this.start,
    required this.home,
  });
}
