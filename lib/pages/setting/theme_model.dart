import 'package:flutter/material.dart';

class ThemeModel {
  /// 用户选择的明暗模式
  bool themeDarkMode = false;

  /// 当前主题颜色
  MaterialColor themeColor = Colors.blue;

  /// 当前字体索引
  int themeFontIndex = 0;

  /// 字体选择列表
  var fontValueList = ['system'];
}
