import 'dart:io';

class Quiz {
  final String quizName;
  final String quizDescription;
  final File quizThumbnail;
  final List<String> questionName;
  final List<File> questionImage;
  final List<Map<int, String>> questionAnswer;
  final String startName;
  final File startImage;
  final String startDescription;
  final List<String> finalNames;
  final List<File> finalImages;
  final String finalDescription;
  final List<int> mostFrequentNames;
  final List<int> results;

  Quiz(this.results,
      {required this.quizName,
      required this.quizDescription,
      required this.quizThumbnail,
      required this.questionName,
      required this.questionImage,
      required this.questionAnswer,
      required this.startName,
      required this.startImage,
      required this.startDescription,
      required this.finalNames,
      required this.finalImages,
      required this.finalDescription,
      required this.mostFrequentNames});
}
