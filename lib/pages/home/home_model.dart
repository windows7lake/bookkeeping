import 'package:flutter/material.dart';

class HomeModel {
  /// Drawer 选中 Item 的 index
  int selectedIndex = 0;

  /// 存储上次点击返回按钮的时间
  DateTime lastPressed;

  /// 全局key，用于Drawer的相关操作
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
}
