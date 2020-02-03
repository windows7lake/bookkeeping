import 'package:flutter/material.dart';

class ScreenExt {
  factory ScreenExt() => _getInstance();

  static ScreenExt get instance => _getInstance();
  static ScreenExt _instance;

  ScreenExt._internal();

  static ScreenExt _getInstance() {
    if (_instance == null) {
      _instance = ScreenExt._internal();
    }
    return _instance;
  }

  double _width;
  double _height;
  double _statusBarHeight;
  double _bottomBarHeight;

  double get width => _width;

  double get height => _height;

  double get statusBarHeight => _statusBarHeight;

  double get bottomBarHeight => _bottomBarHeight;

  void init(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    _statusBarHeight = MediaQuery.of(context).padding.top;
    _bottomBarHeight = MediaQuery.of(context).padding.bottom;
  }
}
