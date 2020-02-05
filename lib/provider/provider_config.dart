import 'package:bookkeeping/pages/account/account_controller.dart';
import 'package:bookkeeping/pages/account/account_page.dart';
import 'package:bookkeeping/pages/detail/detail_controller.dart';
import 'package:bookkeeping/pages/detail/detail_page.dart';
import 'package:bookkeeping/pages/home/home_controller.dart';
import 'package:bookkeeping/pages/home/home_page.dart';
import 'package:bookkeeping/pages/setting/locale_controller.dart';
import 'package:bookkeeping/pages/setting/theme_controller.dart';
import 'package:bookkeeping/pages/subject/subject_controller.dart';
import 'package:bookkeeping/pages/subject/subject_page.dart';
import 'package:bookkeeping/pages/user/user_controller.dart';
import 'package:bookkeeping/pages/user/user_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProviderConfig {
  /// 工厂模式创建单例
  factory ProviderConfig() => _getInstance();

  static ProviderConfig get instance => _getInstance();
  static ProviderConfig _instance;

  ProviderConfig._internal();

  static ProviderConfig _getInstance() {
    if (_instance == null) _instance = ProviderConfig._internal();
    return _instance;
  }

  /// 公共
  MultiProvider getGlobal(Widget child) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeController>(
          create: (context) => ThemeController(),
        ),
        ChangeNotifierProvider<LocaleController>(
          create: (context) => LocaleController(),
        ),
      ],
      child: child,
    );
  }

  /// 主页
  get homePage => ChangeNotifierProvider<HomeController>(
        create: (context) => HomeController(),
        child: HomePage(),
      );

  /// 用户
  get userPage => ChangeNotifierProvider<UserController>(
        create: (context) => UserController(),
        child: UserPage(),
      );

  /// 明细
  get detailPage => ChangeNotifierProvider<DetailController>(
        create: (context) => DetailController(),
        child: DetailPage(),
      );

  /// 账户
  get accountPage => ChangeNotifierProvider<AccountController>(
        create: (context) => AccountController(),
        child: AccountPage(),
      );

  /// 科目
  get subjectPage => ChangeNotifierProvider<SubjectController>(
        create: (context) => SubjectController(),
        child: SubjectPage(),
      );
}
