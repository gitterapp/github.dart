import 'package:flutter_github_contributions/flutter_github_contributions.dart';

main() async {
  var login = 'upcwangying'; // replace this with GitHub account you want

  // Get the contribution of a certain year
  // If it is the past year, from: yyyy-12-01, to: yyyy-12-31
  // if not, from: The first day of the current month, to: today
  var contributions = await getContributions(login, from: '2019-08-01', to: '2019-08-04');
  print(contributions[0].color);

  // get svg string
  String svg = await getContributionsSvg(login);
  print(svg);

  // get color and count of this year's contribution
  var contributions1 = await getContributions(login);
  print(contributions1[0].color);
}