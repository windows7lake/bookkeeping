import 'package:bookkeeping/network/json/safe_convert.dart';

class PageBean {
  bool first;
  bool last;
  int totalElements;
  List<DetailBean> content;

  PageBean({
    this.first,
    this.last,
    this.totalElements,
    this.content,
  });

  PageBean.fromJson(Map<String, dynamic> json)
      : first = SafeManager.parseBoolean(json, 'first'),
        last = SafeManager.parseBoolean(json, 'last'),
        totalElements = SafeManager.parseInt(json, 'totalElements'),
        content = SafeManager.parseList(json, 'content')
            ?.map((e) => DetailBean.fromJson(e))
            ?.toList();

  Map<String, dynamic> toJson() => {
        'first': this.first,
        'last': this.last,
        'totalElements': this.totalElements,
        'content': this.content,
      };
}

class DetailBean {
  int id;
  int userId;
  String username;
  int sourceAccountId;
  String sourceAccountName;
  int destAccountId;
  String destAccountName;
  int subjectId;
  String subjectName;
  String remark;
  String createdAt;
  String updatedAt;
  int amount;

  DetailBean({
    this.id,
    this.userId,
    this.username,
    this.sourceAccountId,
    this.sourceAccountName,
    this.destAccountId,
    this.destAccountName,
    this.subjectId,
    this.subjectName,
    this.remark,
    this.createdAt,
    this.updatedAt,
    this.amount,
  });

  DetailBean.fromJson(Map<String, dynamic> json)
      : id = SafeManager.parseInt(json, 'id'),
        userId = SafeManager.parseInt(json, 'userId'),
        username = SafeManager.parseString(json, 'username'),
        sourceAccountId = SafeManager.parseInt(json, 'sourceAccountId'),
        sourceAccountName = SafeManager.parseString(json, 'sourceAccountName'),
        destAccountId = SafeManager.parseInt(json, 'destAccountId'),
        destAccountName = SafeManager.parseString(json, 'destAccountName'),
        subjectId = SafeManager.parseInt(json, 'subjectId'),
        subjectName = SafeManager.parseString(json, 'subjectName'),
        remark = SafeManager.parseString(json, 'remark'),
        createdAt = SafeManager.parseString(json, 'createdAt'),
        updatedAt = SafeManager.parseString(json, 'updatedAt'),
        amount = SafeManager.parseInt(json, 'amount');

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'userId': this.userId,
        'username': this.username,
        'sourceAccountId': this.sourceAccountId,
        'sourceAccountName': this.sourceAccountName,
        'destAccountId': this.destAccountId,
        'destAccountName': this.destAccountName,
        'subjectId': this.subjectId,
        'subjectName': this.subjectName,
        'remark': this.remark,
        'createdAt': this.createdAt,
        'updatedAt': this.updatedAt,
        'amount': this.amount,
      };
}
