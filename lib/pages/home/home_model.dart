import 'package:flutter/material.dart';

class HomeModel {
  /// Drawer 选中 Item 的 index
  int selectedIndex = 0;

  /// 全局key，用于Drawer的相关操作
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
}
