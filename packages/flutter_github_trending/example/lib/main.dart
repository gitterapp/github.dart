import 'package:flutter_github_trending/flutter_github_trending.dart';

main() async {
  // get trending repositories
  var repos = await getTrendingRepositories();
  print(repos[0].owner);

  // specify time period
  var weeklyRepos =
  await getTrendingRepositories(since: TrendingSince.weekly);
  print(weeklyRepos[0].name);

  // specify language
  var dartRepos = await getTrendingRepositories(language: 'dart');
  print(dartRepos[0].primaryLanguage.name); // Dart
  print(dartRepos[0].primaryLanguage.color); // #00B4AB

  // get trending developers
  var devs = await getTrendingDevelopers();
  print(devs[0].avatar);

  // specify time period
  var weeklyDevs =
  await getTrendingDevelopers(since: TrendingSince.weekly);
  print(weeklyDevs[0].avatar);
  print(weeklyDevs[0].username);
  print(weeklyDevs[0].popularRepository?.url);
  print(weeklyDevs[0].popularRepository?.name);

}