import 'dart:io';

import 'package:bookkeeping/pages/user/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class UserPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new UserPageState();
}

class UserPageState extends State<UserPage> {
  final TextStyle textStyleTitle = new TextStyle(
    color: Colors.white,
    fontSize: 28.0,
    fontWeight: FontWeight.w700,
  );
  final TextStyle textStyleName = new TextStyle(
    color: Colors.white,
    fontSize: 20.0,
  );
  final TextStyle textStyleNameHint = new TextStyle(
    color: Colors.grey.shade300,
    fontSize: 20.0,
  );
  UserController _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 初始化controller
    final _controller = Provider.of<UserController>(context)
      ..setContext(context);
    if (_controller != this._controller) this._controller = _controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade300,
      body: renderContent(),
    );
  }

  /// 页面内容
  Widget renderContent() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 80)),
          /// 标题
          GestureDetector(
            onTap: () => _controller.onTitleClick(),
            child: Text("个人信息设置", style: textStyleTitle),
          ),
          Padding(padding: EdgeInsets.only(top: 50)),

          /// 头像
          InkWell(
            onTap: () => _controller.onAvatarClick(),
            child: ClipOval(
              child: SizedBox(
                width: 150.0,
                height: 150.0,
                child: _controller.model.avatarPath.isEmpty
                    ? Image.asset(
                        "assets/images/ic_avatar.png",
                        width: 150,
                        height: 150,
                      )
                    : Image.file(
                        File(_controller.model.avatarPath),
                        width: 150,
                        height: 150,
                      ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 15)),

          /// 昵称编辑框
          Container(
            width: double.infinity,
            child: TextField(
              textAlign: TextAlign.center,
              style: textStyleName,
              autofocus: false,
              maxLines: 1,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.done,
              decoration: new InputDecoration(
                hintText: '昵称',
                hintStyle: textStyleNameHint,
                border: UnderlineInputBorder(borderSide: BorderSide.none),
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(15),
              ],
              controller: _controller.model.editingController,
            ),
          ),

          /// 确认按钮
          InkWell(
            onTap: () => _controller.onConfirmBtnClick(),
            child: Container(
              margin: EdgeInsets.only(top: 50),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(80),
                color: Colors.white,
              ),
              child: Icon(
                Icons.arrow_forward,
                color: Colors.blue.shade300,
                size: 60,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
