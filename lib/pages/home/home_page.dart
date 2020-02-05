import 'dart:io';

import 'package:bookkeeping/pages/home/home_controller.dart';
import 'package:bookkeeping/provider/provider_config.dart';
import 'package:bookkeeping/util/screen_ext.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final TextStyle textStyleName = new TextStyle(
    color: Colors.white,
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
  );

  HomeController _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 初始化controller
    final _controller = Provider.of<HomeController>(context);
    if (_controller != this._controller) this._controller = _controller;
  }

  @override
  Widget build(BuildContext context) {
    ScreenExt.instance.init(context);
    return Scaffold(
      key: _controller.model.scaffoldKey,
      drawer: renderDrawer(),
      body: WillPopScope(
        onWillPop: () => _controller.onBackKeyClick(),
        child: IndexedStack(
          index: _controller.model.selectedIndex,
          children: <Widget>[
            ProviderConfig.instance.detailPage, // 明细
            ProviderConfig.instance.accountPage, // 账户
            ProviderConfig.instance.subjectPage, // 科目
          ],
        ),
      ),
    );
  }

  /// 抽屉栏
  Widget renderDrawer() {
    final int selectedIndex = _controller.model.selectedIndex;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          /// 头像和昵称
          Container(
            height: 150,
            color: Theme.of(context).accentColor,
            child: Row(children: <Widget>[
              Padding(padding: EdgeInsets.only(left: 20)),
              ClipOval(
                child: _controller.getAvatarPath().isEmpty
                    ? Image.asset(
                        "assets/images/ic_avatar.png",
                        width: 80,
                        height: 80,
                      )
                    : Image.file(
                        File(_controller.getAvatarPath()),
                        width: 80,
                        height: 80,
                      ),
              ),
              Padding(padding: EdgeInsets.only(left: 15)),
              Text(_controller.getUsername(), style: textStyleName),
            ]),
          ),
          ListTile(
            leading: Icon(Icons.subject),
            title: Text("明细"),
            selected: selectedIndex == 0,
            onTap: () => _controller.onDrawerItemSelected(0),
          ),
          ListTile(
            leading: Icon(Icons.account_box),
            title: Text("账户"),
            selected: selectedIndex == 1,
            onTap: () => _controller.onDrawerItemSelected(1),
          ),
          ListTile(
            leading: Icon(Icons.assignment),
            title: Text("科目"),
            selected: selectedIndex == 2,
            onTap: () => _controller.onDrawerItemSelected(2),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("设置"),
            selected: selectedIndex == 3,
            onTap: () => _controller.onDrawerItemSelected(3),
          ),
        ],
      ),
    );
  }
}
