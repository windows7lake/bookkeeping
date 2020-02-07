import 'dart:async';

import 'package:bookkeeping/l10n/intl_localizations.dart';
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

    /// 网络连接状态变化
    _subscription = new Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      switch (result) {
        case ConnectivityResult.mobile:
        case ConnectivityResult.wifi:
          setNetworkState(PageState.content);
          onRetry();
          break;
        default:
          setNetworkState(PageState.netError);
          break;
      }
    });
  }

  /// 更新网络连接状态
  void setNetworkState(PageState pageState) {
    if (pageState == PageState.none) return;
    setState(() => _pageState = pageState);

    /// 此处用于将_pageState重置为none
    Future.delayed(
      const Duration(seconds: 1),
      () => _pageState = PageState.none,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: renderStatePage(
        _pageState == PageState.none ? widget.pageState : _pageState,
      ),
    );
  }

  /// 根据状态值渲染对应的页面
  Widget renderStatePage(PageState pageState) {
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
            text: IntlLocalizations.of(context).empty,
          ),
        );

      /// 错误页面
      case PageState.error:
        return InkWell(
          onTap: () => onRetry(),
          child: CommonStatePage(
            image: "assets/images/state_error.png",
            text: IntlLocalizations.of(context).error,
          ),
        );

      /// 网络连接错误页面
      case PageState.netError:
        return InkWell(
          onTap: () => onRetry(),
          child: CommonStatePage(
            image: "assets/images/state_error.png",
            text: IntlLocalizations.of(context).errorNetwork,
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
      const Duration(seconds: 1),
      () => widget.onRetry(),
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

enum PageState { none, loading, empty, error, netError, content }
