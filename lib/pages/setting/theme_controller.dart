import 'dart:math';

import 'package:bookkeeping/cache/sp/sp_manager.dart';
import 'package:bookkeeping/cache/sp/sp_params.dart';
import 'package:bookkeeping/pages/setting/theme_model.dart';
import 'package:bookkeeping/provider/base_controller.dart';
import 'package:bookkeeping/util/theme_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeController extends BaseController<ThemeModel> {
  ThemeController() {
    model = ThemeModel();
    init();
  }

  void init() {
    // 用户选择的明暗模式
    model.themeDarkMode = SpManager.getBool(SpParams.themeDarkMode);
    // 获取主题色
    model.themeColor = Colors
        .primaries[SpManager.getInt(SpParams.themeColorIndex, defaultValue: 5)];
    // 获取字体
    model.themeFontIndex = SpManager.getInt(SpParams.themeColorIndex);
  }

  /// 切换指定色彩
  ///
  /// 没有传[brightness]就不改变brightness,color同理
  void switchTheme({bool themeDarkMode, MaterialColor color}) {
    model.themeDarkMode = themeDarkMode ?? model.themeDarkMode;
    model.themeColor = color ?? model.themeColor;
    notifyListeners();
    saveTheme2Storage(model.themeDarkMode, model.themeColor);
  }

  /// 随机一个主题色彩
  ///
  /// 可以指定明暗模式,不指定则保持不变
  void switchRandomTheme({Brightness brightness}) {
    int colorIndex = Random().nextInt(Colors.primaries.length - 1);
    switchTheme(
      themeDarkMode: Random().nextBool(),
      color: Colors.primaries[colorIndex],
    );
  }

  /// 切换字体
  switchFont(int index) {
    model.themeFontIndex = index;
    switchTheme();
    saveFontIndex(index);
  }

  /// 根据主题 明暗 和 颜色 生成对应的主题
  /// [dark]系统的Dark Mode
  themeData({bool platformDarkMode: false}) {
    var isDark = platformDarkMode || model.themeDarkMode;
    Brightness brightness = isDark ? Brightness.dark : Brightness.light;

    var themeColor = model.themeColor;
    var accentColor = isDark ? themeColor[700] : model.themeColor;
    var themeData = ThemeData(
      brightness: brightness,
      // 主题颜色属于亮色系还是属于暗色系(eg:dark时,AppBarTitle文字及状态栏文字的颜色为白色,反之为黑色)
      // 这里设置为dark目的是,不管App是明or暗,都将appBar的字体颜色的默认值设为白色.
      // 再AnnotatedRegion<SystemUiOverlayStyle>的方式,调整响应的状态栏颜色
      primaryColorBrightness: Brightness.dark,
      accentColorBrightness: Brightness.dark,
      primarySwatch: themeColor,
      accentColor: accentColor,
      fontFamily: model.fontValueList[model.themeFontIndex],
    );

    themeData = themeData.copyWith(
      brightness: brightness,
      accentColor: accentColor,
      cupertinoOverrideTheme: CupertinoThemeData(
        primaryColor: themeColor,
        brightness: brightness,
      ),
      appBarTheme: themeData.appBarTheme.copyWith(elevation: 0),
      splashColor: themeColor.withAlpha(50),
      hintColor: themeData.hintColor.withAlpha(90),
      errorColor: Colors.red,
      cursorColor: accentColor,
      textTheme: themeData.textTheme.copyWith(
        // 解决中文hint不居中的问题 https://github.com/flutter/flutter/issues/40248
        subhead: themeData.textTheme.subhead
            .copyWith(textBaseline: TextBaseline.alphabetic),
      ),
      textSelectionColor: accentColor.withAlpha(60),
      textSelectionHandleColor: accentColor.withAlpha(60),
      toggleableActiveColor: accentColor,
      chipTheme: themeData.chipTheme.copyWith(
        pressElevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 10),
        labelStyle: themeData.textTheme.caption,
        backgroundColor: themeData.chipTheme.backgroundColor.withOpacity(0.1),
      ),
      inputDecorationTheme: ThemeExt.inputDecorationTheme(themeData),
    );
    return themeData;
  }

  /// 数据持久化到shared preferences
  saveTheme2Storage(bool themeDarkMode, MaterialColor themeColor) {
    var index = Colors.primaries.indexOf(themeColor);
    SpManager.setInt(SpParams.themeColorIndex, index);
    SpManager.setBool(SpParams.themeDarkMode, themeDarkMode);
  }

  /// 根据索引获取字体名称,这里牵涉到国际化
  static String fontName(index, context) {
    switch (index) {
      case 0:
        return '自动';
      default:
        return '';
    }
  }

  /// 字体选择持久化
  static saveFontIndex(int index) {
    SpManager.setInt(SpParams.themeFontIndex, index);
  }
}
