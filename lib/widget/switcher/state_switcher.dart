import 'dart:async';

import 'package:bookkeeping/util/log_ext.dart';
import 'package:bookkeeping/widget/switcher/common_state_page.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

typedef OnRetry = void Function();

/// 状态转换器（根据定义的条件切换当前页面，同时加入了对网络状态的监听）<br>
class StateSwitcher extends StatefulWidget {
  final PageState pageState;
  final Widget skeleton;
  final Widget child;
  final OnRetry onRetry;

  StateSwitcher({
    Key key,
    this.pageState,
    this.skeleton,
    this.child,
    this.onRetry,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StateSwitcherState();
}

class _StateSwitcherState extends State<StateSwitcher> {
  var _pageState;
  var _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = new Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile) {
        setNetworkState(PageState.content);
      } else if (result == ConnectivityResult.wifi) {
        setNetworkState(PageState.content);
      } else {
        setNetworkState(PageState.netError);
      }
      onRetry();
    });
  }

  /// 更新网络连接状态
  void setNetworkState(PageState pageState) {
    setState(() => _pageState = pageState);
  }

  @override
  Widget build(BuildContext context) {
    final state =
        (_pageState == PageState.netError) ? _pageState : widget.pageState;
    return Material(
      type: MaterialType.transparency,
      child: renderStatePage(state),
    );
  }

  /// 根据状态值渲染对应的页面
  Widget renderStatePage(PageState pageState) {
    LogExt.log("===== 页面状态 => ${pageState.toString()} =====");
    switch (pageState) {

      /// 加载中...
      case PageState.loading:
        if (widget.skeleton != null) return widget.skeleton;
        return Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        );

      /// 空页面
      case PageState.empty:
        return InkWell(
          onTap: () => onRetry(),
          child: CommonStatePage(
            image: "assets/images/state_empty.png",
            text: "无数据~",
          ),
        );

      /// 错误页面
      case PageState.error:
        return InkWell(
          onTap: () => onRetry(),
          child: CommonStatePage(
            image: "assets/images/state_error.png",
            text: "请求错误，请重试",
          ),
        );

      /// 网络连接错误页面
      case PageState.netError:
        return InkWell(
          onTap: () => onRetry(),
          child: CommonStatePage(
            image: "assets/images/state_error.png",
            text: "网络连接错误，请检查后再重试",
          ),
        );

      /// 正常内容页面
      default:
        return widget.child;
    }
  }

  /// 重试
  void onRetry() {
    if (widget.onRetry == null) return;
    setNetworkState(PageState.loading);
    Future.delayed(
      const Duration(milliseconds: 300),
      () => widget.onRetry(),
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

enum PageState { loading, empty, error, netError, content }
