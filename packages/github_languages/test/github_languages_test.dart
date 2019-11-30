import 'package:flutter_test/flutter_test.dart';

import 'package:github_languages/github_languages.dart';

void main() {
  group('get network languages', () {
    List<Language> languages;

    setUp(() async {
      languages = await getNetworkLanguages();
    });

    test('has data', () {
      expect(languages.length, isNonZero);
    });

    test('field not null', () {
      languages.forEach((info) {
        expect(info.text, isNotNull);
      });
    });
  });

  group('get cache languages', () {
    List<Language> languages;

    setUp(() async {
      languages = await getCacheLanguages();
    });

    test('has data', () {
      expect(languages.length, isNonZero);
    });
  });
}
