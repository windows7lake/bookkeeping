import 'package:bookkeeping/network/json/safe_convert.dart';

class SubjectList {
  List<SubjectBean> list;

  SubjectList({this.list});

  SubjectList.fromJson(List<dynamic> json)
      : list = json.map((e) => SubjectBean.fromJson(e)).toList();
}

class SubjectBean {
  int id;
  String name;
  String description;
  String tags;

  SubjectBean({
    this.id,
    this.name,
    this.description,
    this.tags,
  });

  SubjectBean.fromJson(Map<String, dynamic> json)
      : id = SafeManager.parseInt(json, 'id'),
        name = SafeManager.parseString(json, 'name'),
        description = SafeManager.parseString(json, 'description'),
        tags = SafeManager.parseString(json, 'tags');

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'name': this.name,
        'description': this.description,
        'tags': this.tags,
      };
}
