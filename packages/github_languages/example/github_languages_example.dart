import 'package:github_languages/github_languages.dart';

/// A demo.
void main() async {
  List<Language> languages = await getCacheLanguages();
  print(languages[0].text);
}
