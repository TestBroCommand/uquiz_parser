import 'package:uquiz_parser/quiz_temp.dart';
import 'package:uquiz_parser/uquiz_parser.dart' as uquiz_parser;

void main(List<String> arguments) async {
  List<QuizTemp> quizResults = await uquiz_parser
      .getQuizzes(['hRaAfq', 'czUHxv', 'nAaEe0', 'xytvJO', 'PqfIW9']);
  print('Quiz results: $quizResults');
}
