# Github Languages

[![GitHub release](https://img.shields.io/github/release/upcwangying/flutter-github-languages)](https://github.com/upcwangying/flutter-github-languages)
[![Pub](https://img.shields.io/pub/v/github_languages)](https://pub.dev/packages/github_languages)

A library to get `GitHub languages` for Dart and Flutter developers.

## Installation

Add `github_languages` as a [dependency in your pubspec.yaml file](https://flutter.dev/docs/development/packages-and-plugins/using-packages)

```
dependencies:
  github_languages: '<latest version>'
```

## Usage

```
import 'package:github_languages/github_languages.dart';

/// A demo.
void main() async {
  List<Language> languages = await getLanguages();
  print(languages[0].text);
}
```

## License

MIT
