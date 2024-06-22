import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;

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
    dom.Document document = html_parser.parse(html);

    dom.Element? ogTitleMeta =
        document.querySelector('meta[property="og:title"]');

    if (ogTitleMeta != null) {
      String? ogTitle = ogTitleMeta.attributes['content'];
      return ogTitle ?? 'og:title content not found';
    } else {
      return 'og:title meta tag not found';
    }
  }

  static String _extractImageUrl(String html) {
    dom.Document document = html_parser.parse(html);

    dom.Element? ogImg = document.querySelector('meta[name="twitter:image"]');

    if (ogImg != null) {
      String? ogTitle = ogImg.attributes['content'];
      return ogTitle ?? 'og:img content not found';
    } else {
      return 'og:img meta tag not found';
    }
  }

  static String _extractDescription(String html) {
    dom.Document document = html_parser.parse(html);

    dom.Element? ogDescMeta =
        document.querySelector('meta[property="og:description"]');

    if (ogDescMeta != null) {
      String? ogDesc = ogDescMeta.attributes['content'];
      return ogDesc ?? 'og:description content not found';
    } else {
      return 'og:description meta tag not found';
    }
  }
}
