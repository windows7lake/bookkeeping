import 'dart:io';

import 'package:bookkeeping/cache/sp/sp_manager.dart';
import 'package:bookkeeping/cache/sp/sp_params.dart';
import 'package:bookkeeping/network/api/api.dart';
import 'package:bookkeeping/network/api/http_request.dart';
import 'package:bookkeeping/pages/user/setup_ip_dialog.dart';
import 'package:bookkeeping/pages/user/user_bean.dart';
import 'package:bookkeeping/pages/user/user_model.dart';
import 'package:bookkeeping/provider/base_controller.dart';
import 'package:bookkeeping/routes/route_manager.dart';
import 'package:bookkeeping/routes/route_params.dart';
import 'package:bookkeeping/util/dialog_ext.dart';
import 'package:bookkeeping/util/toast_ext.dart';
import 'package:bookkeeping/widget/dialog/image_picker_dialog.dart';
import 'package:bookkeeping/widget/dialog/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class UserController extends BaseController<UserModel> {
  BuildContext _context;

  UserController() {
    model = UserModel();
  }

  void setContext(BuildContext context) {
    this._context = context;
  }

  /// 创建用户
  void createUser() {
    HttpRequest.getInstance().post(
      Api.USER,
      rawData: {
        "account": "",
        "username": model.editingController.text.toString(),
        "avatar": "",
      },
      callBack: (data) {
        // json数据解析并添加到数据列表
        var userBean = UserBean.fromJson(data);
        SpManager.setBool(SpParams.firstLoad, false);
        SpManager.setInt(SpParams.userId, userBean.id);
        SpManager.setString(SpParams.username, userBean.username);
        RouteManager.instance.pushReplacement(RoutePageType.home);
      },
      errorCallBack: (error) {
        ToastExt.show(error.toString());
      },
      commonCallBack: () => DialogExt.instance.hideDialog(_context),
    );
  }

  /// 头像点击
  void onAvatarClick() {
    DialogExt.instance.showNewDialog(
      _context,
      ImagePickerDialog(
        onImageFile: (file) async {
          var appDocDir = await getApplicationDocumentsDirectory();
          var newFile = await file.copy(
              "${appDocDir.path}/avatar${DateTime.now().millisecondsSinceEpoch}.png");
          model.avatarPath = newFile.path;
          notifyListeners();
          SpManager.setString(SpParams.avatar, newFile.path);
        },
      ),
      dismiss: true,
      bottomSheet: true,
    );
  }

  /// 确认按钮点击
  void onConfirmBtnClick() {
    DialogExt.instance.showNewDialog(_context, LoadingDialog());
    createUser();
  }

  DateTime lastDateTime; // 上次点击的时间
  int times = 0; // 点击次数

  /// 标题点击
  void onTitleClick() {
    if (lastDateTime == null) {
      times++;
      lastDateTime = DateTime.now();
      return;
    }
    if (DateTime.now().difference(lastDateTime) < Duration(seconds: 2)) {
      times++;
      lastDateTime = DateTime.now();
      if (times > 2) {
        ToastExt.cancel();
        ToastExt.show("再点击${5 - times}次");
      }
      if (times > 4) {
        DialogExt.instance.showNewDialog(
          _context,
          SetupIpDialog(onConfirmClick: () {
            times = 0;
            lastDateTime = null;
          }),
        );
      }
    } else {
      times = 0;
    }
  }
}
