import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_github_contributions/flutter_github_contributions.dart';

var login = 'upcwangying';

void main() {
  group('get contributions', () {
    List<Contribution> contributions;

    setUp(() async {
      contributions = await getContributions(login);
    });

    test('has data', () {
      expect(contributions.length, isNonZero);
    });

    test('field not null', () {
      contributions.forEach((info) {
        expect(info.color, isNotNull);
        expect(info.count, isNotNull);
        expect(info.date, isNotNull);
      });
    });

    test('data format', () {
      contributions.forEach((info) {
        expect(RegExp(r'#\w{6}').hasMatch(info.color), isTrue);
        expect(info.count, greaterThanOrEqualTo(0));
        expect(RegExp(r'\d{4}-\d{2}-\d{2}').hasMatch(info.date), isTrue);
      });
    });
  });

  group('get contributions with from and to', () {
    List<Contribution> contributions;

    setUp(() async {
      contributions =
          await getContributions(login, from: '2019-08-01', to: '2019-08-04');
    });

    test('has data', () {
      expect(contributions.length, isNonZero);
    });

    test('length', () {
      int count = 0;
      contributions.where((contribution) {
        return contribution.count > 0;
      }).forEach((contribution) {
        count += contribution.count;
      });
      expect(count, 402);
    });

    test('field not null', () {
      contributions.forEach((info) {
        expect(info.color, isNotNull);
        expect(info.count, isNotNull);
        expect(info.date, isNotNull);
      });
    });

    test('data format', () {
      contributions.forEach((info) {
        expect(RegExp(r'#\w{6}').hasMatch(info.color), isTrue);
        expect(info.count, greaterThanOrEqualTo(0));
        expect(RegExp(r'\d{4}-\d{2}-\d{2}').hasMatch(info.date), isTrue);
      });
    });
  });

  group('get contributions svg', () {
    String svg;

    setUp(() async {
      svg = await getContributionsSvg(login);
    });

    test('has data', () {
      expect(svg, isNotNull);
    });

    test('is svg tag', () {
      expect(svg, startsWith('<svg'));
      expect(svg, endsWith('</svg>'));
    });
    test('has no text tag', () {
      expect(svg, isNot(contains('</text>')));
    });
  });

  group('get contributions svg without text', () {
    String svg;

    setUp(() async {
      svg = await getContributionsSvg(login, keepDateText: true);
    });

    test('has data', () {
      expect(svg, isNotNull);
    });

    test('is svg tag', () {
      expect(svg, startsWith('<svg'));
      expect(svg, endsWith('</svg>'));
    });
  });
}
