import 'package:bookkeeping/cache/db/subject_dao.dart';
import 'package:bookkeeping/pages/subject/subject_bean.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class SubjectModel {
  List<SubjectBean> list;
  String errorMsg = "";

  final EasyRefreshController refreshController = EasyRefreshController();
  TextEditingController tagsEditingController = TextEditingController();
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController descEditingController = TextEditingController();

  SubjectDao subjectDao = SubjectDao();
}
