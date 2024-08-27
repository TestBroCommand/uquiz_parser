# UquizParser

## Description
UquizParser is a Dart package designed to parse Uquiz data efficiently. It provides a simple interface to extract and manipulate quiz information.

## Installation
To use uquiz_parser in your Dart application, follow these steps:

1. **Add the dependency** to your `pubspec.yaml` file:
   ```yaml
   dependencies:
     uquiz_parser:
       git:
         url: https://github.com/TestBroCommand/uquiz_parser.git
   ```

2. **Install the package** by running:
   ```bash
   dart pub get
   ```

## Usage
1. **Import** the package in your Dart file:
   ```dart
   import 'package:uquiz_parser/uquiz_parser.dart';
   ```

2. **Use** the provided functions to parse Uquiz data:
   ```dart
   var parser = UquizParser();
   var quizData = parser.parse(yourQuizData);
   ```

## Contributing
1. **Fork** the repository.
2. **Create** a new branch:
   ```bash
   git checkout -b feature/your-feature
   ```
3. **Commit** your changes:
   ```bash
   git commit -am 'Add some feature'
   ```
4. **Push** to the branch:
   ```bash
   git push origin feature/your-feature
   ```
5. **Submit** a pull request.

## License
This project is licensed under the MIT License.
