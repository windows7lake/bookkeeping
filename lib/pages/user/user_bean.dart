import 'package:bookkeeping/network/json/safe_convert.dart';

class UserBean {
  int id;
  String username;
  String account;
  String avatar;

  UserBean({
    this.id,
    this.username,
    this.account,
    this.avatar,
  });

  UserBean.fromJson(Map<String, dynamic> json)
      : id = SafeManager.parseInt(json, 'id'),
        username = SafeManager.parseString(json, 'username'),
        account = SafeManager.parseString(json, 'account'),
        avatar = SafeManager.parseString(json, 'avatar');

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'username': this.username,
        'account': this.account,
        'avatar': this.avatar,
      };
}
