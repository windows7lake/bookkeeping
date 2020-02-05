import 'package:flutter/material.dart';

class ThemeModel {
  /// 用户选择的明暗模式
  bool themeDarkMode;

  /// 当前主题颜色
  MaterialColor themeColor;

  /// 当前字体索引
  int themeFontIndex;

  /// 字体选择列表
  var fontValueList = ['system'];
}
