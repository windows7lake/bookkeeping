import 'dart:collection';

import 'package:bookkeeping/routes/route_params.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteManager extends NavigatorObserver {
  /// 路由表配置
  static Map<String, WidgetBuilder> configRoutes;

  /// 当前路由栈
  List<Route> get routes => _mRoutes;

  /// 当前路由
  Route get currentRoute => _mRoutes[_mRoutes.length - 1];

  /// 工厂模式创建单例
  factory RouteManager() => _getInstance();

  static RouteManager get instance => _getInstance();
  static List<Route> _mRoutes;
  static RouteManager _instance;

  RouteManager._internal() {
    _mRoutes = List<Route>();
    configRoutes = HashMap<String, WidgetBuilder>();
    RouteParams.configRoutes.forEach((pageType, widget) {
      configRoutes.putIfAbsent(pageType.toString(), () => (context) => widget);
    });
  }

  static RouteManager _getInstance() {
    if (_instance == null) _instance = RouteManager._internal();
    return _instance;
  }

  /// replace 页面
  pushReplacement(RoutePageType routeName, [Widget widget]) {
    var widgetBuilder = widget != null
        ? (context) => widget
        : configRoutes[routeName.toString()];
    return navigator.pushReplacement(
      CupertinoPageRoute(
        builder: widgetBuilder,
        settings: RouteSettings(name: routeName.toString()),
      ),
    );
  }

  /// push 页面
  push(RoutePageType routeName, [Widget widget]) {
    var widgetBuilder = widget != null
        ? (context) => widget
        : configRoutes[routeName.toString()];
    return navigator.push(
      CupertinoPageRoute(
        builder: widgetBuilder,
        settings: RouteSettings(name: routeName.toString()),
      ),
    );
  }

  /// pop 页面
  pop<T extends Object>([T result]) {
    navigator.pop(result);
  }

  /// push一个页面， 移除该页面下面所有页面
  pushNamedAndRemoveUntil(RoutePageType newRouteName) {
    return navigator.pushNamedAndRemoveUntil(
        newRouteName.toString(), (Route<dynamic> route) => false);
  }

  /// 当调用Navigator.push时回调
  @override
  void didPush(Route route, Route previousRoute) {
    super.didPush(route, previousRoute);
    // 这里过滤调push的是dialog的情况
    if (route is CupertinoPageRoute || route is MaterialPageRoute) {
      _mRoutes.add(route);
      routeObserver();
    }
  }

  /// 当调用Navigator.pop时回调
  @override
  void didPop(Route route, Route previousRoute) {
    super.didPop(route, previousRoute);
    if (route is CupertinoPageRoute || route is MaterialPageRoute) {
      _mRoutes.remove(route);
      routeObserver();
    }
  }

  @override
  void didRemove(Route route, Route previousRoute) {
    super.didRemove(route, previousRoute);
    if (route is CupertinoPageRoute || route is MaterialPageRoute) {
      _mRoutes.remove(route);
      routeObserver();
    }
  }

  /// 当调用Navigator.replace时回调
  @override
  void didReplace({Route newRoute, Route oldRoute}) {
    super.didReplace();
    if (newRoute is CupertinoPageRoute || newRoute is MaterialPageRoute) {
      _mRoutes.remove(oldRoute);
      _mRoutes.add(newRoute);
      routeObserver();
    }
  }

//  // stream相关，用于监听路由跳转
//  static StreamController _streamController;
//
//  StreamController get streamController => _streamController;
//
  void routeObserver() {}
}
