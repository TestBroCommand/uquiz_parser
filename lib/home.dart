class Home {
  final String name;
  final String description;
  final String imageUrl;
  Home({
    required this.description,
    required this.name,
    required this.imageUrl,
  });
  factory Home.fromJson(String html, String quizId) {
    final name = _extractName(html);
    final imageUrl = _extractImageUrl(html);
    final description = _extractDescription(html);
    return Home(
      description: description,
      name: name,
      imageUrl: imageUrl,
    );
  }
  static String _extractName(String html) {
    final regExp = RegExp(r'<meta property="og:title" content="([^"]+)">');
    final match = regExp.firstMatch(html);
    return match!.group(1)!.trim();
  }

  static String _extractImageUrl(String html) {
    final regExp = RegExp(r'<meta name="og:image" content="([^"]+)">');
    final match = regExp.firstMatch(html);
    return match!.group(1)!.trim();
  }

  static String _extractDescription(String html) {
    final regExp =
        RegExp(r'<meta property="og:description" content="([^"]+)">');
    final match = regExp.firstMatch(html);
    return match!.group(1)!.trim();
  }
}
