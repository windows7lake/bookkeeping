import 'package:bookkeeping/cache/sp/sp_manager.dart';
import 'package:bookkeeping/cache/sp/sp_params.dart';
import 'package:bookkeeping/l10n/intl_localizations.dart';
import 'package:bookkeeping/network/api/api.dart';
import 'package:bookkeeping/network/api/http_request.dart';
import 'package:bookkeeping/pages/detail/detail_bean.dart';
import 'package:bookkeeping/pages/detail/detail_create_dialog.dart';
import 'package:bookkeeping/pages/detail/detail_model.dart';
import 'package:bookkeeping/pages/home/home_controller.dart';
import 'package:bookkeeping/provider/base_controller.dart';
import 'package:bookkeeping/provider/base_state.dart';
import 'package:bookkeeping/util/dialog_ext.dart';
import 'package:bookkeeping/util/regex_ext.dart';
import 'package:bookkeeping/util/toast_ext.dart';
import 'package:bookkeeping/widget/dialog/loading_dialog.dart';
import 'package:bookkeeping/widget/switcher/state_switcher.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailController extends BaseController<DetailModel>
    implements BaseState {
  BuildContext _context;
  HomeController _homeController;

  DetailController() {
    model = DetailModel();
  }

  void setContext(BuildContext context) {
    this._context = context;
    _homeController = Provider.of<HomeController>(_context);
  }

  /// 加载明细列表数据
  void getDetailList() {
    HttpRequest.getInstance().get(
      Api.DETAIL,
      params: {"page": model.curPage},
      callBack: (data) {
        // 如果list为未初始化，先初始化
        if (model.list == null) model.list = List();
        // 请求成功，清空错误信息
        model.errorMsg = "";
        // json数据解析并添加到数据列表
        var dataBean = PageBean.fromJson(data);
        model.list.addAll(dataBean.content);
        // 是否还有加载更多
        if (dataBean.content.length == 0) onLoadMoreState(true);

        notifyListeners();
      },
      errorCallBack: (error) => handleError(error.toString()),
    );
  }

  /// 创建明细
  void createDetail() {
    HttpRequest.getInstance().post(
      Api.DETAIL,
      rawData: {
        "userId": SpManager.getInt(SpParams.userId),
        "sourceAccountId": model.sourceAccountSelected?.id ?? 0,
        "destAccountId": model.destAccountSelected?.id ?? 0,
        "subjectId": model.subjectSelected?.id ?? 0,
        "updatedAt": model.dateTime?.toUtc()?.toIso8601String() ?? "",
        "amount": double.parse(model.amountEditingController.text) * 100,
        "remark": model.remarkEditingController.text,
      },
      callBack: (data) {
        DialogExt.instance.hideDialog(_context);

        // json数据解析并添加到数据列表
        var detailBean = DetailBean.fromJson(data);
        model.list.add(detailBean);
        model.amountEditingController.clear();
        model.remarkEditingController.clear();

        notifyListeners();
      },
      errorCallBack: (error) {
        ToastExt.show(error.toString());
      },
      commonCallBack: () => DialogExt.instance.hideDialog(_context),
    );
  }

  /// 修改明细
  void editDetail(int position, int id) {
    HttpRequest.getInstance().put(
      Api.DETAIL + "/$id",
      rawData: {
        "userId": SpManager.getInt(SpParams.userId),
        "sourceAccountId": model.sourceAccountSelected?.id ?? 0,
        "destAccountId": model.destAccountSelected?.id ?? 0,
        "subjectId": model.subjectSelected?.id ?? 0,
        "updatedAt": model.dateTime?.toUtc()?.toIso8601String() ?? "",
        "amount": double.parse(model.amountEditingController.text) * 100,
        "remark": model.remarkEditingController.text,
      },
      callBack: (data) {
        DialogExt.instance.hideDialog(_context);

        // json数据解析并添加到数据列表
        var detailBean = DetailBean.fromJson(data);
        model.list[position] = detailBean;
        model.amountEditingController.clear();
        model.remarkEditingController.clear();

        notifyListeners();
      },
      errorCallBack: (error) {
        ToastExt.show(error.toString());
      },
      commonCallBack: () => DialogExt.instance.hideDialog(_context),
    );
  }

  /// 删除明细
  void deleteDetailItem(int position) {
    final itemData = model.list[position];
    HttpRequest.getInstance().delete(
      Api.DETAIL + "/${itemData.id}",
      callBack: (data) {
        DialogExt.instance.hideDialog(_context);
        model.list.removeAt(position);
        notifyListeners();
      },
      errorCallBack: (error) {
        ToastExt.show(IntlLocalizations.of(_context).hintDeleteFail);
      },
      commonCallBack: () => DialogExt.instance.hideDialog(_context),
    );
  }

  /// 删除明细操作
  void deleteDetailItemOperation(int position) {
    DialogExt.instance.showNewDialog(
      _context,
      CupertinoAlertDialog(
        content: Text(
          IntlLocalizations.of(_context).hintDeleteDialogTitle,
          style: TextStyle(fontSize: 16),
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text(IntlLocalizations.of(_context).hintYes),
            onPressed: () {
              DialogExt.instance.showNewDialog(_context, LoadingDialog());
              deleteDetailItem(position);
            },
          ),
          CupertinoDialogAction(
            child: Text(IntlLocalizations.of(_context).hintNo),
            onPressed: () => DialogExt.instance.hideDialog(_context),
          )
        ],
      ),
    );
  }

  /// 添加按钮点击
  void onAddBtnClick() async {
    await getSubjectData();
    await getAccountData();
    DialogExt.instance.showNewDialog(
      _context,
      DetailCreateDialog(
        accountList: model.accountList,
        subjectList: model.subjectList,
        amountEditingController: model.amountEditingController,
        remarkEditingController: model.remarkEditingController,
        onAddClick: (sourceAccountSelected, destAccountSelected,
            subjectSelected, dateTime) {
          model.sourceAccountSelected = sourceAccountSelected;
          model.destAccountSelected = destAccountSelected;
          model.subjectSelected = subjectSelected;
          model.dateTime = dateTime;
          checkAndSubmitData();
          createDetail();
        },
        onCreateItemClick: (index) {
          // 此处的index和Drawer中账户和科目所处的位置相对应
          _homeController.onDrawerItemSelected(index);
        },
      ),
      dismiss: true,
    );
  }

  /// 检查并提交数据
  void checkAndSubmitData() {
    if (model.subjectSelected?.name ==
        IntlLocalizations.of(_context).detailHintSubject) {
      ToastExt.show(IntlLocalizations.of(_context).detailHintSubject);
      return;
    }
    if (model.sourceAccountSelected?.name ==
        IntlLocalizations.of(_context).detailHintAccount) {
      ToastExt.show(IntlLocalizations.of(_context).detailHintAccount);
      return;
    }
    if (model.amountEditingController.text.isEmpty) {
      ToastExt.show(IntlLocalizations.of(_context).detailHintAmountNone);
      return;
    }
    if (!RegexExt.isMoney(model.amountEditingController.text)) {
      ToastExt.show(IntlLocalizations.of(_context).detailHintAmountAccuracy);
      return;
    }
    DialogExt.instance.showNewDialog(_context, LoadingDialog());
  }

  /// 获取账户信息
  Future<void> getAccountData() async {
    var list = await model.accountDao.queryAll();
    if (list == null) return;
    model.accountList.clear();
    model.accountList.addAll(list);
    if (model.accountList.isNotEmpty) {
      model.sourceAccountSelected = model.accountList[0];
      model.destAccountSelected = model.accountList[0];
    }
  }

  /// 获取科目信息
  Future<void> getSubjectData() async {
    var list = await model.subjectDao.queryAll();
    if (list == null) return;
    model.subjectList.clear();
    model.subjectList.addAll(list);
    if (model.subjectList.isNotEmpty) {
      model.subjectSelected = model.subjectList[0];
    }
  }

  /// 日期格式化
  String getFormatDate(String date) {
    if (date == null || date.isEmpty) return "";
    return formatDate(DateTime.parse(date), [yyyy, '年', mm, '月', dd, '日']);
  }

  /// Item点击
  void onItemClick(int position, DetailBean detailBean) async {
    await getSubjectData();
    await getAccountData();
    DialogExt.instance.showNewDialog(
      _context,
      DetailCreateDialog(
        detailBean: detailBean,
        accountList: model.accountList,
        subjectList: model.subjectList,
        amountEditingController: model.amountEditingController,
        remarkEditingController: model.remarkEditingController,
        onAddClick: (sourceAccountSelected, destAccountSelected,
            subjectSelected, dateTime) {
          model.sourceAccountSelected = sourceAccountSelected;
          model.destAccountSelected = destAccountSelected;
          model.subjectSelected = subjectSelected;
          model.dateTime = dateTime;
          checkAndSubmitData();
          editDetail(position, detailBean.id);
        },
        onCreateItemClick: (index) {
          // 此处的index和Drawer中账户和科目所处的位置相对应
          _homeController.onDrawerItemSelected(index);
        },
      ),
      dismiss: true,
    );
  }

  /// 格式化金额
  String formatMoney(int money) {
    if (money == null) return "";
    return "${money.toDouble() / 100}";
  }

  /// 获取头像路径
  String getAvatarPath() {
    return SpManager.getString(SpParams.avatar);
  }

  /// 打开Drawer
  void openDrawer() {
    _homeController.openDrawer();
  }

  /// 错误处理
  void handleError(String msg) {
    model.errorMsg = msg;
    notifyListeners();
  }

  /// 加载更多状态设置
  void onLoadMoreState(bool noMore) {
    model.refreshController.finishLoad(success: true, noMore: noMore);
  }

  /// 刷新列表
  Future<void> onRefresh() async {
    model.curPage = 0;
    model.list?.clear();
    getDetailList();
  }

  /// 列表加载更多
  Future<void> onLoadMore() async {
    model.curPage++;
    getDetailList();
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
