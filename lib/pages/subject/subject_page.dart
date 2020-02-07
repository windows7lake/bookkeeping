import 'dart:io';

import 'package:bookkeeping/l10n/intl_localizations.dart';
import 'package:bookkeeping/pages/home/home_controller.dart';
import 'package:bookkeeping/pages/subject/subject_controller.dart';
import 'package:bookkeeping/pages/subject/subject_skeleton.dart';
import 'package:bookkeeping/widget/switcher/state_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:provider/provider.dart';

class SubjectPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new SubjectPageState();
}

class SubjectPageState extends State<SubjectPage> {
  final TextStyle textStyleContent = new TextStyle(
    color: Colors.black,
    fontSize: 14.0,
  );
  final TextStyle textStyleHint = new TextStyle(
    color: Colors.grey,
    fontSize: 12.0,
  );

  SubjectController _controller;
  HomeController _homeController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 初始化controller
    final _controller = Provider.of<SubjectController>(context)
      ..setContext(context);
    if (_controller != this._controller) this._controller = _controller;
    final _homeController = Provider.of<HomeController>(context);
    if (_homeController != this._homeController)
      this._homeController = _homeController;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppBar(),
      body: renderContent(),
    );
  }

  /// 导航栏
  Widget renderAppBar() {
    return AppBar(
      // 设置状态栏字体颜色
      brightness: Brightness.dark,
      centerTitle: true,
      title: Text(
        IntlLocalizations.of(context).titleSubject,
        style: TextStyle(color: Colors.white),
      ),
      leading: Padding(
        padding: EdgeInsets.all(10),
        child: GestureDetector(
          onTap: () => _homeController.openDrawer(),
          child: ClipOval(
            child: _controller.getAvatarPath().isEmpty
                ? Image.asset(
                    "assets/images/ic_avatar.png",
                    width: 30,
                    height: 30,
                  )
                : Image.file(
                    File(_controller.getAvatarPath()),
                    width: 30,
                    height: 30,
                  ),
          ),
        ),
      ),
      actions: <Widget>[
        // 添加按钮
        IconButton(
          icon: Icon(Icons.add, color: Colors.white),
          color: Colors.black,
          tooltip: IntlLocalizations.of(context).hintAdd,
          onPressed: () => _controller.onAddBtnClick(),
        )
      ],
      elevation: 2,
    );
  }

  /// 渲染内容部分（科目列表）
  Widget renderContent() {
    return StateSwitcher(
      skeleton: SubjectSkeleton(),
      pageState: _controller.switchState(),
      onRetry: () => _controller.onRefresh(),
      child: EasyRefresh(
        controller: _controller.model.refreshController,
        onRefresh: () => _controller.onRefresh(),
        header: MaterialHeader(),
        child: GridView.builder(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 2.0,
            mainAxisSpacing: 2.0,
          ),
          itemCount: _controller.model.list?.length ?? 0,
          itemBuilder: (_, position) => renderListItem(position),
        ),
      ),
    );
  }

  /// 渲染List Item
  Widget renderListItem(int position) {
    final itemData = _controller.model.list[position];
    return InkWell(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue.shade200, width: 1),
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: Stack(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "${itemData?.name ?? ""}",
                  style: textStyleContent,
                ),
                Text(
                  "${IntlLocalizations.of(context).subjectLabelDesc}"
                  "：${itemData?.description ?? IntlLocalizations.of(context).none}",
                  style: textStyleHint,
                ),
              ],
            ),
          ),
          Positioned(
            right: 8,
            top: -5,
            child: Icon(
              Icons.bookmark,
              color: Colors.blue.shade200,
              size: 30,
            ),
          )
        ]),
      ),
    );
  }
}
