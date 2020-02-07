import 'package:bookkeeping/cache/db/account_dao.dart';
import 'package:bookkeeping/cache/sp/sp_manager.dart';
import 'package:bookkeeping/cache/sp/sp_params.dart';
import 'package:bookkeeping/l10n/intl_localizations.dart';
import 'package:bookkeeping/network/api/api.dart';
import 'package:bookkeeping/network/api/http_request.dart';
import 'package:bookkeeping/pages/account/account_bean.dart';
import 'package:bookkeeping/pages/account/account_create_dialog.dart';
import 'package:bookkeeping/pages/account/account_model.dart';
import 'package:bookkeeping/provider/base_controller.dart';
import 'package:bookkeeping/provider/base_state.dart';
import 'package:bookkeeping/util/dialog_ext.dart';
import 'package:bookkeeping/util/toast_ext.dart';
import 'package:bookkeeping/widget/dialog/loading_dialog.dart';
import 'package:bookkeeping/widget/switcher/state_switcher.dart';
import 'package:flutter/material.dart';

class AccountController extends BaseController<AccountModel>
    implements BaseState {
  BuildContext _context;

  AccountController() {
    model = AccountModel();
  }

  void setContext(BuildContext context) {
    this._context = context;
  }

  /// 加载账户列表
  void getAccountList() {
    HttpRequest.getInstance().get(
      Api.ACCOUNT,
      callBack: (data) async {
        // 如果list为未初始化，先初始化
        if (model.list == null) model.list = List();
        // 请求成功，清空错误信息
        model.errorMsg = "";
        // json数据解析并添加到数据列表
        var dataBean = AccountList.fromJson(data);
        model.list.addAll(dataBean.list);
        model.refreshController.finishLoad(success: true, noMore: true);
        // 数据库存储
        await model.accountDao.deleteAll();
        dataBean.list.forEach((accountBean) {
          model.accountDao.insert(Account(
            id: accountBean.id,
            name: accountBean.name,
            type: accountBean.type,
            description: accountBean.description,
          ));
        });

        notifyListeners();
      },
      errorCallBack: (error) => handleError(error.toString()),
    );
  }

  /// 创建账户
  void createAccount() {
    HttpRequest.getInstance().post(
      Api.ACCOUNT,
      rawData: {
        "userId": SpManager.getInt(SpParams.userId),
        "type": model.typeEditingController.text,
        "name": model.nameEditingController.text,
        "description": model.descEditingController.text,
      },
      callBack: (data) {
        DialogExt.instance.hideDialog(_context);

        // json数据解析并添加到数据列表
        var accountBean = AccountBean.fromJson(data);
        model.list.add(accountBean);
        model.typeEditingController.clear();
        model.nameEditingController.clear();
        model.descEditingController.clear();
        // 数据库存储
        model.accountDao.insert(Account(
          id: accountBean.id,
          name: accountBean.name,
          type: accountBean.type,
          description: accountBean.description,
        ));

        notifyListeners();
      },
      errorCallBack: (error) {
        ToastExt.show(error.toString());
      },
      commonCallBack: () => DialogExt.instance.hideDialog(_context),
    );
  }

  /// 添加按钮点击
  void onAddBtnClick() {
    DialogExt.instance.showNewDialog(
      _context,
      AccountCreateDialog(
        typeEditingController: model.typeEditingController,
        nameEditingController: model.nameEditingController,
        descEditingController: model.descEditingController,
        onAddClick: () => checkAndSubmitData(),
      ),
      dismiss: true,
    );
  }

  /// 检查并提交数据
  void checkAndSubmitData() {
    if (model.typeEditingController.text.isEmpty) {
      ToastExt.show(IntlLocalizations.of(_context).accountHintTypeNone);
      return;
    }
    if (model.nameEditingController.text.isEmpty) {
      ToastExt.show(IntlLocalizations.of(_context).accountHintNameNone);
      return;
    }
    DialogExt.instance.showNewDialog(_context, LoadingDialog());
    createAccount();
  }

  /// 获取头像路径
  String getAvatarPath() {
    return SpManager.getString(SpParams.avatar);
  }

  /// 错误处理
  void handleError(String msg) {
    model.errorMsg = msg;
    notifyListeners();
  }

  /// 刷新列表
  Future<void> onRefresh() async {
    model.list?.clear();
    getAccountList();
  }

  @override
  bool empty() => model.list != null && model.list.isEmpty;

  @override
  bool error() => model.errorMsg.isNotEmpty;

  @override
  bool loading() => model.list == null;

  @override
  PageState switchState() {
    if (error()) return PageState.error;
    if (loading()) return PageState.loading;
    if (empty()) return PageState.empty;
    return PageState.content;
  }
}
