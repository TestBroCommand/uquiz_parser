import 'package:uquiz_parser/quiz.dart';
import 'package:uquiz_parser/uquiz_parser.dart' as uquiz_parser;

void main(List<String> arguments) async {
  List<Quiz> quizResults = await uquiz_parser
      .getQuizzes(['hRaAfq', 'czUHxv', 'nAaEe0', 'xytvJO', 'PqfIW9']);
  print('Quiz results: ${quizResults[0].home.name}');
}
//TODO images pocketbase