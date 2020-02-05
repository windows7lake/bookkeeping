import 'package:bookkeeping/pages/setting/setting_page.dart';
import 'package:bookkeeping/provider/provider_config.dart';
import 'package:flutter/material.dart';

class RouteParams {
  /// 路由表配置
  static Map<RoutePageType, Widget> configRoutes = {
    RoutePageType.home: ProviderConfig.instance.homePage,
    RoutePageType.user: ProviderConfig.instance.userPage,
    RoutePageType.detail: ProviderConfig.instance.detailPage,
    RoutePageType.account: ProviderConfig.instance.accountPage,
    RoutePageType.subject: ProviderConfig.instance.subjectPage,
    RoutePageType.setting: SettingPage(),
  };
}

/// 路由页面枚举值-便于获取指定页面
enum RoutePageType {
  none,
  user, // 用户
  home, // 主页
  detail, // 明细
  account, // 账户
  subject, // 科目
  setting, // 设置
}
