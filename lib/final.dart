import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;

class Final {
  final String name;
  final String description;
  final String imageUrl;
  Final({
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  factory Final.fromJson(String html) {
    final name = _extractName(html);
    final imageUrl = _extractImageUrl(html);
    final description = _extractDescription(html);
    return Final(
      description: description,
      name: name,
      imageUrl: imageUrl,
    );
  }
  static String _extractImageUrl(String html) {
    dom.Document document = html_parser.parse(html);

    dom.Element? imgElement = document.querySelector(
        'img[class="personality_image large_personality_image"]');

    if (imgElement != null) {
      String? ogTitle = imgElement.attributes['src'];
      return ogTitle ?? 'og:img content not found';
    } else {
      return 'og:img meta tag not found';
    }
  }

  static String _extractName(String html) {
    dom.Document document = html_parser.parse(html);

    dom.Element? nameElement =
        document.querySelector('h4[class="personality_name"]');

    if (nameElement != null) {
      String name = nameElement.text;
      return name;
    } else {
      return 'og:name meta tag not found';
    }
  }

  static String _extractDescription(String html) {
    dom.Document document = html_parser.parse(html);

    dom.Element? descriptionElement =
        document.querySelector('div[class="personality_description"]');

    if (descriptionElement != null) {
      String description = descriptionElement.text;
      return description;
    } else {
      return 'og:desc meta tag not found';
    }
  }
}
