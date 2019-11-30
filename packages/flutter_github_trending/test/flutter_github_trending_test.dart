import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_github_trending/flutter_github_trending.dart';

void main() {
  List<TrendingRepository> repositories;
  List<TrendingDeveloper> developers;

  group('get trending repositories', () {
    setUpAll(() async {
      repositories = await getTrendingRepositories();
    });

    test('has data', () {
      expect(repositories, isList);
    });

    test('owner, name are not null', () {
      repositories.forEach((item) {
        expect(item.owner, isNotNull);
        expect(item.name, isNotNull);
      });
    });

    test('star and fork count', () {
      // make sure at least one item has star or fork
      // to ensure no parse error
      var itemHasStar = repositories.where((item) => item.starCount != null);
      expect(itemHasStar, isNotEmpty);

      var itemHasFork = repositories.where((item) => item.forkCount != null);
      expect(itemHasFork, isNotEmpty);
    });

    test('primary language', () {
      repositories.forEach((item) {
        if (item.primaryLanguage != null) {
          expect(item.primaryLanguage.name, isNotNull);
          expect(item.primaryLanguage.color, isNotNull);
          // CSS color format
          expect(
              RegExp(r'#[0-9a-fA-F]{3,6}').hasMatch(item.primaryLanguage.color),
              isTrue);
        }
      });
    });
  });

  group('get trending developers', () {
    setUpAll(() async {
      developers = await getTrendingDevelopers();
    });

    test('has data', () {
      expect(developers, isList);
    });

    test('length of data', () {
      expect(developers.length, 25);
    });

    test('has avatar, username and nickname', () {
      // make sure at least one item has star or fork
      // to ensure no parse error
      var itemHasNickname = developers.where((item) => item.nickname != null);
      expect(itemHasNickname, isNotEmpty);

      var itemHasUsername = developers.where((item) => item.username != null);
      expect(itemHasUsername, isNotEmpty);

      var itemHasAvatar = developers.where((item) => item.avatar != null);
      expect(itemHasAvatar, isNotEmpty);
    });

    test('popular repository', () {
      developers.forEach((item) {
        if (item.popularRepository != null) {
          expect(item.popularRepository.name, isNotNull);
          expect(item.popularRepository.url, isNotNull);
        }
      });
    });
  });

  group('specify language', () {
    setUpAll(() async {
      repositories = await getTrendingRepositories(language: 'dart');
    });

    test('has data', () {
      expect(repositories, isList);
    });

    test('correct language', () {
      repositories.forEach((item) {
        expect(item.primaryLanguage, isNotNull);
        expect(item.primaryLanguage.name, equals('Dart'));
      });
    });
  });
}
