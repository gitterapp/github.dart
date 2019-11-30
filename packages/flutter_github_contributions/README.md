# Github Contributions

[![GitHub release](https://img.shields.io/github/release/upcwangying/flutter-github-contributions)](https://github.com/upcwangying/flutter-github-contributions)
[![Pub](https://img.shields.io/pub/v/flutter_github_contributions)](https://pub.dev/packages/flutter_github_contributions)

A library to get `GitHub contributions` for Dart and Flutter developers.

## Installation

Add `flutter_github_contributions` as a [dependency in your pubspec.yaml file](https://flutter.dev/docs/development/packages-and-plugins/using-packages)

```
dependencies:
  flutter_github_contributions: '<latest version>'
```

## Usage

```
import 'package:flutter_github_contributions/flutter_github_contributions.dart';

main() async {
  var login = 'upcwangying'; // replace this with GitHub account you want
  
  // Get the contribution of a certain year
  // If it is the past year, from: yyyy-12-01, to: yyyy-12-31
  // if not, from: The first day of the current month, to: today
  var contributions =
          await getContributions(login, from: '2019-08-01', to: '2019-08-04');
  print(contributions[0].color);

  // get svg string
  String svg = await getContributionsSvg(login);
  print(svg);

  // get color and count of this year's contribution
  var contributions = await getContributions(login);
  print(contributions[0].color);
}
```

## License

MIT
