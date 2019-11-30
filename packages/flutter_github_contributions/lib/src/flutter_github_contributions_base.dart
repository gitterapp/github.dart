import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

class Contribution {
  int count;
  String color;
  String date;

  Contribution({this.count, this.color, this.date});

  Contribution.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    color = json['color'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['color'] = this.color;
    data['date'] = this.date;
    return data;
  }
}

Future<List<Contribution>> getContributions(
  String login, {
  String from,
  String to,
}) async {
  var url = 'https://github.com/$login';
  if (from != null && to != null) {
    url += '?from=$from&to=$to';
  }
  var res = await http.get(url);
  var document = parse(res.body);
  var rectNodes =
      document.querySelector('.js-calendar-graph-svg').querySelectorAll('rect');
  return rectNodes.map((rectNode) {
    return Contribution(
      color: rectNode.attributes['fill'],
      count: int.tryParse(rectNode.attributes['data-count']),
      date: rectNode.attributes['data-date'],
    );
  }).toList();
}

/// Get user contributions data as svg string
Future<String> getContributionsSvg(
  String login, {
  bool keepDateText = false,
  String from,
  String to,
}) async {
  var url = 'https://github.com/$login';
  if (from != null && to != null) {
    url += '?from=$from&to=$to';
  }
  var res = await http.get(url);
  var document = parse(res.body);
  var svgNode = document.querySelector('.js-calendar-graph-svg');

  if (!keepDateText) {
    // remove text tags
    svgNode.children[0].children.forEach((child) {
      if (child.localName == 'text') {
        child.remove();
      }
    });

    // resize
    // the size depend on if use check the 'Activity overview' option
    if (svgNode.attributes['width'] == '563') {
      svgNode.attributes['width'] = '528';
      svgNode.attributes['height'] = '68';
      svgNode.children[0].attributes['transform'] = 'translate(-11, 0)';
    } else {
      svgNode.attributes['width'] = '637';
      svgNode.attributes['height'] = '84';
      svgNode.children[0].attributes['transform'] = 'translate(-13, 0)';
    }
  }

  return svgNode?.outerHtml;
}
