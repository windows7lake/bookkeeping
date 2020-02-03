import 'package:bookkeeping/cache/db/account_dao.dart';
import 'package:bookkeeping/cache/db/subject_dao.dart';
import 'package:bookkeeping/pages/detail/detail_bean.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class DetailModel {
  List<DetailBean> list;
  String errorMsg = "";
  int curPage = 0;

  final EasyRefreshController refreshController = EasyRefreshController();
  TextEditingController amountEditingController = TextEditingController();
  TextEditingController remarkEditingController = TextEditingController();

  AccountDao accountDao = AccountDao();
  SubjectDao subjectDao = SubjectDao();
  List<Account> accountList = List();
  List<Subject> subjectList = List();
  Account sourceAccountSelected;
  Account destAccountSelected;
  Subject subjectSelected;
  DateTime dateTime = DateTime.now();
}
