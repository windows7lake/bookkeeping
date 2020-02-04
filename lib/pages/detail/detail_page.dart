import 'dart:io';

import 'package:bookkeeping/pages/detail/detail_controller.dart';
import 'package:bookkeeping/pages/detail/detail_skeleton.dart';
import 'package:bookkeeping/widget/switcher/state_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/ball_pulse_footer.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new DetailPageState();
}

class DetailPageState extends State<DetailPage> {
  final TextStyle textStyleContent = new TextStyle(
    color: Colors.black,
    fontSize: 14.0,
  );
  final TextStyle textStyleDelete = new TextStyle(
    color: Colors.white,
    fontSize: 12.0,
  );

  DetailController _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 初始化controller
    final _controller = Provider.of<DetailController>(context)
      ..setContext(context);
    if (_controller != this._controller) {
      this._controller = _controller;
    }
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
        "明细",
        style: TextStyle(color: Colors.white),
      ),
      leading: Padding(
        padding: EdgeInsets.all(10),
        child: GestureDetector(
          onTap: () => _controller.openDrawer(),
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

  /// 渲染内容部分（明细列表）
  Widget renderContent() {
    return StateSwitcher(
      skeleton: DetailSkeleton(),
      pageState: _controller.switchState(),
      onRetry: () => _controller.onRefresh(),
      child: EasyRefresh(
        controller: _controller.model.refreshController,
        onRefresh: () => _controller.onRefresh(),
        onLoad: () => _controller.onLoadMore(),
        header: MaterialHeader(),
        footer: BallPulseFooter(),
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
      onTap: () => _controller.onItemClick(itemData),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Stack(children: <Widget>[
          /// 内容
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "科目：${itemData?.subjectName ?? ""}",
                style: textStyleContent,
              ),
              Text(
                "金额：￥${itemData?.amount ?? ""}",
                style: textStyleContent,
              ),
              Text(
                "来源账户：${itemData?.sourceAccountName ?? ""}",
                style: textStyleContent,
              ),
              Text(
                "目标账户：${itemData?.destAccountName ?? ""}",
                style: textStyleContent,
              ),
              Text(
                "日期：${_controller.getFormatDate(itemData?.updatedAt)}",
                style: textStyleContent,
              ),
              Text(
                "备注：${itemData?.remark ?? ""}",
                style: textStyleContent,
              ),
            ],
          ),

          /// 删除按钮
          Positioned(
            right: 0,
            top: 0,
            child: SizedBox(
              height: 28,
              width: 65,
              child: FlatButton(
                color: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                onPressed: () =>
                    _controller.deleteDetailItemOperation(position),
                child: Text("删除", style: textStyleDelete),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
