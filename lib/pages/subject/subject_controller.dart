import 'package:bookkeeping/cache/db/subject_dao.dart';
import 'package:bookkeeping/cache/sp/sp_manager.dart';
import 'package:bookkeeping/cache/sp/sp_params.dart';
import 'package:bookkeeping/l10n/intl_localizations.dart';
import 'package:bookkeeping/network/api/api.dart';
import 'package:bookkeeping/network/api/http_request.dart';
import 'package:bookkeeping/pages/subject/subject_bean.dart';
import 'package:bookkeeping/pages/subject/subject_create_dialog.dart';
import 'package:bookkeeping/pages/subject/subject_model.dart';
import 'package:bookkeeping/provider/base_controller.dart';
import 'package:bookkeeping/provider/base_state.dart';
import 'package:bookkeeping/util/dialog_ext.dart';
import 'package:bookkeeping/util/toast_ext.dart';
import 'package:bookkeeping/widget/dialog/loading_dialog.dart';
import 'package:bookkeeping/widget/switcher/state_switcher.dart';
import 'package:flutter/material.dart';

class SubjectController extends BaseController<SubjectModel>
    implements BaseState {
  BuildContext _context;

  SubjectController() {
    model = SubjectModel();
  }

  void setContext(BuildContext context) {
    this._context = context;
  }

  /// 加载科目列表
  void getSubjectList() {
    HttpRequest.getInstance().get(
      Api.SUBJECT,
      callBack: (data) async {
        // 如果list为未初始化，先初始化
        if (model.list == null) model.list = List();
        // 请求成功，清空错误信息
        model.errorMsg = "";
        // json数据解析并添加到数据列表
        var dataBean = SubjectList.fromJson(data);
        model.list.addAll(dataBean.list);
        model.refreshController.finishLoad(success: true, noMore: true);
        // 数据库存储
        await model.subjectDao.deleteAll();
        dataBean.list.forEach((accountBean) {
          model.subjectDao.insert(Subject(
            id: accountBean.id,
            name: accountBean.name,
            tags: accountBean.tags,
            description: accountBean.description,
          ));
        });

        notifyListeners();
      },
      errorCallBack: (error) => handleError(error.toString()),
    );
  }

  /// 创建科目
  void createSubject() {
    HttpRequest.getInstance().post(
      Api.SUBJECT,
      rawData: {
        "userId": SpManager.getInt(SpParams.userId),
        "tags": model.tagsEditingController.text,
        "name": model.nameEditingController.text,
        "description": model.descEditingController.text,
      },
      callBack: (data) {
        DialogExt.instance.hideDialog(_context);

        // json数据解析并添加到数据列表
        var subjectBean = SubjectBean.fromJson(data);
        model.list.add(subjectBean);
        model.tagsEditingController.clear();
        model.nameEditingController.clear();
        model.descEditingController.clear();
        // 数据库存储
        model.subjectDao.insert(Subject(
          id: subjectBean.id,
          name: subjectBean.name,
          tags: subjectBean.tags,
          description: subjectBean.description,
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
      SubjectCreateDialog(
        tagsEditingController: model.tagsEditingController,
        nameEditingController: model.nameEditingController,
        descEditingController: model.descEditingController,
        onAddClick: () => checkAndSubmitData(),
      ),
      dismiss: true,
    );
  }

  /// 检查并提交数据
  void checkAndSubmitData() {
    if (model.tagsEditingController.text.isEmpty) {
      ToastExt.show(IntlLocalizations.of(_context).subjectHintTagsNone);
      return;
    }
    if (model.nameEditingController.text.isEmpty) {
      ToastExt.show(IntlLocalizations.of(_context).subjectHintNameNone);
      return;
    }
    DialogExt.instance.showNewDialog(_context, LoadingDialog());
    createSubject();
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
    getSubjectList();
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
