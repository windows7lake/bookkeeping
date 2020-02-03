import 'package:bookkeeping/cache/db/account_dao.dart';
import 'package:bookkeeping/pages/account/account_bean.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class AccountModel {
  List<AccountBean> list;
  String errorMsg = "";

  final EasyRefreshController refreshController = EasyRefreshController();
  TextEditingController typeEditingController = TextEditingController();
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController descEditingController = TextEditingController();

  AccountDao accountDao = AccountDao();
}
