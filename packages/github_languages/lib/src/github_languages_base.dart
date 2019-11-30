import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:yaml/yaml.dart';

/// .
class Language {
  String text;
  String color;

  Language({this.text, this.color});

  factory Language.fromJson(Map<String, dynamic> json) {
    return json == null
        ? null
        : Language(
      text: json['text'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['color'] = this.color;
    return data;
  }
}

Future<List<Language>> getNetworkLanguages() async {
  var yamlUrl = 'https://raw.githubusercontent.com/github/linguist/master/lib/linguist/languages.yml';
  var resYaml = await http.get(yamlUrl);
  var yaml = loadYaml(resYaml.body);

  List<Language> languages = [];
  yaml.nodes.forEach((key, value) {
    languages.add(Language(
      text: key.value,
      color: value['color'] ?? '#cccccc',
    ));
  });

  return languages;
}

Future<List<Language>> getCacheLanguages() async {
  var jsonStr = await rootBundle.loadString('assets/languages.json');
  var data = jsonDecode(jsonStr);
  print(data);

  List<Language> languages = [];
  data.forEach((language) {
    languages.add(Language.fromJson(language));
  });

  return languages;
}
