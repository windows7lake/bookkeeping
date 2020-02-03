import 'package:bookkeeping/network/json/safe_convert.dart';

class AccountList {
  List<AccountBean> list;

  AccountList({this.list});

  AccountList.fromJson(List<dynamic> json)
      : list = json.map((e) => AccountBean.fromJson(e)).toList();
}

class AccountBean {
  int id;
  String type;
  String name;
  String description;
  String username;

  AccountBean({
    this.id,
    this.type,
    this.name,
    this.description,
    this.username,
  });

  AccountBean.fromJson(Map<String, dynamic> json)
      : id = SafeManager.parseInt(json, 'id'),
        type = SafeManager.parseString(json, 'type'),
        name = SafeManager.parseString(json, 'name'),
        description = SafeManager.parseString(json, 'description'),
        username = SafeManager.parseString(json, 'username');

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'type': this.type,
        'name': this.name,
        'description': this.description,
        'username': this.username,
      };
}
