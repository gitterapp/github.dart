import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

const URL = 'https://github.com';

///
class TrendingType {
  static const repository = 'repository';
  static const developer = 'developer';
}

///
class TrendingSince {
  static const daily = 'daily';
  static const weekly = 'weekly';
  static const monthly = 'monthly';
}

/// trending repositories model
class TrendingRepository {
  String owner;
  String avatar;
  String name;
  String description;
  String descriptionHTML;
  int starCount;
  int forkCount;
  String stars;
  PrimaryLanguage primaryLanguage;
  List<RepositoryBuildBy> buildBys;

  TrendingRepository({
    this.owner,
    this.avatar,
    this.name,
    this.description,
    this.descriptionHTML,
    this.starCount,
    this.forkCount,
    this.stars,
    this.primaryLanguage,
    this.buildBys,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['owner'] = this.owner;
    data['avatar'] = this.avatar;
    data['name'] = this.name;
    data['description'] = this.description;
    data['descriptionHTML'] = this.descriptionHTML;
    data['starCount'] = this.starCount;
    data['forkCount'] = this.forkCount;
    data['stars'] = this.stars;
    if (this.primaryLanguage != null) {
      data['primaryLanguage'] = this.primaryLanguage.toJson();
    }
    if (this.buildBys != null) {
      data['buildBys'] = this.buildBys.map((v) => v.toJson()).toList();
    }
    return data;
  }

  factory TrendingRepository.fromJson(Map<String, dynamic> json) {
    return json == null
        ? null
        : TrendingRepository(
      owner: json['owner'],
      avatar: json['avatar'],
      name: json['name'],
      description: json['description'],
      descriptionHTML: json['descriptionHTML'],
      starCount: json['starCount'],
      forkCount: json['forkCount'],
      stars: json['stars'],
      primaryLanguage: PrimaryLanguage.fromJson(json['primaryLanguage']),
      buildBys: json['buildBys'] == null
          ? null
          : (json['buildBys'] as List).map((j) => RepositoryBuildBy.fromJson(j)).toList(),
    );
  }
}

class PrimaryLanguage {
  String name;
  String color;

  PrimaryLanguage({this.name, this.color});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = this.name;
    data['color'] = this.color;
    return data;
  }

  factory PrimaryLanguage.fromJson(Map<String, dynamic> json) {
    return json == null
        ? null
        : PrimaryLanguage(
      name: json['name'],
      color: json['color'],
    );
  }
}

class RepositoryBuildBy {
  String avatar;
  String username;

  RepositoryBuildBy({this.avatar, this.username});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avatar'] = this.avatar;
    data['username'] = this.username;
    return data;
  }

  factory RepositoryBuildBy.fromJson(Map<String, dynamic> json) {
    return json == null
        ? null
        : RepositoryBuildBy(
      avatar: json['avatar'],
      username: json['username'],
    );
  }
}

/// trending developers model
class TrendingDeveloper {
  String avatar;
  String username;
  String nickname;
  PopularRepository popularRepository;

  TrendingDeveloper({
    this.avatar,
    this.username,
    this.nickname,
    this.popularRepository,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avatar'] = this.avatar;
    data['username'] = this.username;
    data['nickname'] = this.nickname;
    if (this.popularRepository != null) {
      data['popularRepository'] = this.popularRepository.toJson();
    }
    return data;
  }

  factory TrendingDeveloper.fromJson(Map<String, dynamic> json) {
    return json == null
        ? null
        : TrendingDeveloper(
      avatar: json['avatar'],
      username: json['username'],
      nickname: json['nickname'],
      popularRepository: PopularRepository.fromJson(json['popularRepository']),
    );
  }
}

/// popular repository model
class PopularRepository {
  String url;
  String name;
  String description;
  String descriptionRawHtml;

  PopularRepository(
      {this.url, this.name, this.description, this.descriptionRawHtml});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['name'] = this.name;
    data['description'] = this.description;
    data['descriptionRawHtml'] = this.descriptionRawHtml;
    return data;
  }

  factory PopularRepository.fromJson(Map<String, dynamic> json) {
    return json == null
        ? null
        : PopularRepository(
      url: json['url'],
      name: json['name'],
      description: json['description'],
      descriptionRawHtml: json['descriptionRawHtml'],
    );
  }
}

/// A method to get trending repositories
Future<List<TrendingRepository>> getTrendingRepositories({
  String since,
  String language,
}) async {
  var url = '${URL}/trending';
  if (language != null) {
    url += '/$language';
  }
  if (since != null) {
    url += '?since=$since';
  }

  var res = await http.get(url);
  var document = parse(res.body);
  var items = document.querySelectorAll('.Box-row');

  return items.map((item) {
    PrimaryLanguage primaryLanguage;
    var colorNode = item.querySelector('.repo-language-color');

    if (colorNode != null) {
      primaryLanguage = PrimaryLanguage(
          name: colorNode.nextElementSibling?.innerHtml?.trim(),
          color: RegExp(r'#[0-9a-fA-F]{3,6}')
              .firstMatch(colorNode.attributes['style'])
              ?.group(0));
    }

    var starCountStr = item
        .querySelector('.f6')
        ?.querySelector('.octicon-star')
        ?.parent
        ?.innerHtml
        ?.replaceAll(RegExp(r'^[\s\S]*svg>'), '')
        ?.replaceAll(',', '')
        ?.trim();

    var starCount = starCountStr == null ? null : int.tryParse(starCountStr);

    var forkCountStr = item
        .querySelector('.octicon-repo-forked')
        ?.parent
        ?.innerHtml
        ?.replaceAll(RegExp(r'^[\s\S]*svg>'), '')
        ?.replaceAll(',', '')
        ?.trim();
    var forkCount = forkCountStr == null ? null : int.tryParse(forkCountStr);

    var starsStr = item
        .querySelector('.float-sm-right')
        ?.innerHtml
        ?.replaceAll(RegExp(r'^[\s\S]*svg>'), '')
        ?.replaceAll(',', '')
        ?.trim();

    String description;
    String descriptionHTML;
    var descriptionRawHtml = item.querySelector('p')?.innerHtml?.trim();
    if (descriptionRawHtml != null) {
      description = descriptionRawHtml
          ?.replaceAll(RegExp(r'<g-emoji.*?>'), '')
          ?.replaceAll(RegExp(r'</g-emoji>'), '')
          ?.replaceAll(RegExp(r'<a.*?>'), '')
          ?.replaceAll(RegExp(r'</a>'), '');
      descriptionHTML = '<div>$descriptionRawHtml</div>';
    }

    List<RepositoryBuildBy> buildBys = [];
    var buildByNodes = item.querySelectorAll('.avatar');
    if (buildByNodes != null && buildByNodes.isNotEmpty) {
      buildByNodes.forEach((e) {
        buildBys.add(RepositoryBuildBy(
          avatar: e.attributes['src'],
          username: e.attributes['alt'].replaceFirst('@', ''),
        ));
      });
    }

    var username = item
        .querySelector('.text-normal')
        ?.innerHtml
        ?.replaceFirst('/', '')
        ?.trim();

    var name = item
        .querySelector('.text-normal')
        ?.parent
        ?.innerHtml
        ?.replaceAll(RegExp(r'^[\s\S]*span>'), '')
        ?.trim();

    return TrendingRepository(
      owner: username,
      avatar: '${URL}/${username}.png',
      name: name,
      description: description,
      descriptionHTML: descriptionHTML,
      starCount: starCount,
      forkCount: forkCount,
      stars: starsStr,
      primaryLanguage: primaryLanguage,
      buildBys: buildBys,
    );
  }).toList();
}

/// A method to get trending repositories
Future<List<TrendingDeveloper>> getTrendingDevelopers({
  String since,
  String language,
}) async {
  var url = '${URL}/trending/developers';
  if (language != null) {
    url += '/$language';
  }
  if (since != null) {
    url += '?since=$since';
  }

  var res = await http.get(url);
  var document = parse(res.body);
  var items = document.querySelectorAll('.Box-row');

  return items.map((item) {
    PopularRepository popularRepository;
    var popularNode =
        item.querySelector('.d-sm-flex>div>div')?.nextElementSibling;

    if (popularNode != null) {
      var description = popularNode.querySelector('.mt-1')?.innerHtml?.trim();
      popularRepository = PopularRepository(
        url: popularNode
            .querySelector('div>article>h1>a')
            ?.attributes['href']
            ?.trim(),
        name: popularNode.querySelector('div>article>h1>a')?.text?.trim(),
        description: description
                ?.replaceAll(RegExp(r'<g-emoji.*?>'), '')
                ?.replaceAll(RegExp(r'</g-emoji>'), '')
                ?.replaceAll(RegExp(r'<a.*?>'), '')
                ?.replaceAll(RegExp(r'</a>'), '') ??
            '',
        descriptionRawHtml: '<div>${description ?? ''}</div>',
      );
    }

    return TrendingDeveloper(
      avatar: item.querySelector('.rounded-1')?.attributes['src']?.trim(),
      username: item.querySelector('.link-gray')?.innerHtml?.trim(),
      nickname: item.querySelector('.d-md-flex')?.querySelector('.lh-condensed')?.text?.trim(),
      popularRepository: popularRepository,
    );
  }).toList();
}
