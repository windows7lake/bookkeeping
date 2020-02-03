import 'package:flutter/material.dart';

/// Dialog工具类  <br>
/// 支持普通Dialog的显示以及弹出底部Dialog形式（bottomSheet）  <br>
/// 支持按照优先级别显示  <br>
class DialogExt {
  factory DialogExt() => _getInstance();

  static DialogExt get instance => _getInstance();
  static DialogExt _instance;

  List<DialogBean> _mDialogList; // 用于存储Dialog，其中的key为对应dialog的tag标志

  DialogExt._internal() {
    _mDialogList = new List();
  }

  static DialogExt _getInstance() {
    if (_instance == null) {
      _instance = new DialogExt._internal();
    }
    return _instance;
  }

  int autoId = 999;

  /// 添加Dialog到队列中并直接展示
  ///
  /// @param tag : dialog标志位 <br>
  /// @param dismiss : 点击底部透明部分是否取消dialog <br>
  /// @param bottomSheet : 是否从底部弹出 <br>
  void showNewDialog(
    BuildContext context,
    Widget widget, {
    int tag,
    bool dismiss = false,
    bool bottomSheet = false,
  }) {
    // 自增id：用于获取指定的dialog
    int id = tag == null ? incrementId() : tag;
    _mDialogList.add(DialogBean(id, widget, priority: 1));

    _showNewDialog(
      context,
      id: id,
      dismiss: dismiss,
      bottomSheet: bottomSheet,
    );
  }

  /// 添加Dialog到队列中并等待取出展示
  ///
  /// @param tag : dialog标志位 <br>
  /// @param dismiss : 点击底部透明部分是否取消dialog <br>
  /// @param bottomSheet : 是否从底部弹出 <br>
  /// @param priority : dialog弹出的优先级（优先级：从1..10，1的优先级别最高） <br>
  void addNewDialog(
    BuildContext context,
    Widget widget, {
    int tag,
    bool dismiss = false,
    bool bottomSheet = false,
    int priority = 5,
  }) {
    // 自增id：用于获取指定的dialog
    int id = tag == null ? incrementId() : tag;
    _mDialogList.add(DialogBean(id, widget, priority: priority));
    _mDialogList.sort((a, b) => a.priority.compareTo(b.priority));

    // 如果已经有在展示的Dialog，则不继续弹窗
    int showingSize = _mDialogList.where((e) => e?.showing == true).length;
    if (showingSize > 0) return;

    _showNewDialog(
      context,
      id: id,
      dismiss: dismiss,
      bottomSheet: bottomSheet,
    );
  }

  /// 从队列中取出并展示Dialog
  void _showNewDialog(
    BuildContext context, {
    int id = 0,
    bool dismiss = false,
    bool bottomSheet = false,
  }) async {
    if (_mDialogList.isEmpty) return;
    // 根据tag值获取对应的index
    int index = _mDialogList.indexWhere((e) => e.tag == id);
    if (index == -1) return;
    // 设置当前dialog为展示状态
    _mDialogList[index].showing = true;
    Widget widget = _mDialogList[index].widget;
    if (bottomSheet) {
      await showModalBottomSheet(
        context: context,
        isDismissible: dismiss,
        useRootNavigator: true,
        builder: (BuildContext context) => widget,
      ).then((value) {
        _dismissDialogListener(context, id);
      });
    } else {
      await showDialog(
        context: context,
        barrierDismissible: dismiss,
        useRootNavigator: true,
        builder: (BuildContext context) => widget,
      ).then((value) {
        _dismissDialogListener(context, id);
      });
    }
  }

  /// 弹窗关闭监听
  void _dismissDialogListener(BuildContext context, int id) {
    // 弹窗被关闭时，从列表中移除
    _mDialogList.removeWhere((e) => e.tag == id);
    // 如果已经有在展示的Dialog，则不继续弹窗
    int showingSize = _mDialogList.where((e) => e?.showing == true).length;
    if (showingSize > 0) return;
    // 如果列表中还有弹窗，则继续显示
    if (_mDialogList.isEmpty) return;
    _showNewDialog(context, id: _mDialogList[0].tag, dismiss: true);
  }

  /// 关闭Dialog
  void hideDialog(BuildContext context, {int tag, dynamic result = ""}) {
    // 如果当前没有dialog，则不执行
    if (_mDialogList.isEmpty) return;
    // 如果没有当前dialog，则不执行
    if (tag != null &&
        _mDialogList.where((e) => e?.tag == tag).toList().length == 0) return;
    // 隐藏当前显示的弹窗
    Navigator.of(context, rootNavigator: true).pop(result);
  }

  /// id 自增
  int incrementId() {
    return ++autoId;
  }
}

class DialogBean {
  int tag; // dialog标志位
  int priority; // 优先级：从1..10，1的优先级别最高
  bool showing = false; // 是否正在展示（true：正在展示  false：反之）
  bool dismiss = false; // 点击非内容区域是否关闭dialog（true：关闭   false：不关闭）
  Widget widget; // dialog组件

  DialogBean(
    this.tag,
    this.widget, {
    this.priority,
    this.showing,
    this.dismiss,
  });
}
