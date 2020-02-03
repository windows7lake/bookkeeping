import 'dart:io';

import 'package:bookkeeping/pages/account/account_controller.dart';
import 'package:bookkeeping/pages/home/home_controller.dart';
import 'package:bookkeeping/widget/switcher/state_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  final TextStyle textStyleContent = new TextStyle(
    color: Colors.black,
    fontSize: 14.0,
  );

  AccountController _controller;
  HomeController _homeController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 初始化controller
    final _controller = Provider.of<AccountController>(context)
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
        "账户",
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
          tooltip: "新增",
          onPressed: () => _controller.onAddBtnClick(),
        )
      ],
      elevation: 2,
    );
  }

  /// 渲染内容部分（账户列表）
  Widget renderContent() {
    return StateSwitcher(
      pageState: _controller.switchState(),
      onRetry: () => _controller.onRefresh(),
      child: EasyRefresh(
        controller: _controller.model.refreshController,
        onRefresh: () => _controller.onRefresh(),
        header: MaterialHeader(),
        child: ListView.separated(
          itemCount: _controller.model.list?.length ?? 0,
          itemBuilder: (_, position) => renderListItem(position),
          separatorBuilder: (_, __) =>
              Divider(thickness: 1, height: 1, color: Colors.grey.shade300),
        ),
      ),
    );
  }

  /// 渲染List Item
  Widget renderListItem(int position) {
    final itemData = _controller.model.list[position];
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "类型：${itemData?.type ?? ""}",
              style: textStyleContent,
            ),
            Text(
              "名称：${itemData?.name ?? ""}",
              style: textStyleContent,
            ),
            Text(
              "描述：${itemData?.description ?? ""}",
              style: textStyleContent,
            ),
          ],
        ),
      ),
    );
  }
}
