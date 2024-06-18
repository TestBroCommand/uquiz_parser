class Question {
  final int questionNumber;
  final String questionText;
  // final String? questionImage;
  final List<String> answers;

  Question(
      {required this.questionNumber,
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
    return Question(
      questionNumber: questionNumber,
      //   questionImage: questionImage,
      questionText: questionText,
      answers: answers,
    );
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
