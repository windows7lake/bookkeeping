// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'zh';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "accountHintDesc" : MessageLookupByLibrary.simpleMessage("请输入描述（可选）"),
    "accountHintName" : MessageLookupByLibrary.simpleMessage("请输入名称（必填）"),
    "accountHintNameNone" : MessageLookupByLibrary.simpleMessage("名称不能为空"),
    "accountHintType" : MessageLookupByLibrary.simpleMessage("请输入类型（必填）"),
    "accountHintTypeNone" : MessageLookupByLibrary.simpleMessage("类型不能为空"),
    "accountLabelDesc" : MessageLookupByLibrary.simpleMessage("描述"),
    "accountLabelName" : MessageLookupByLibrary.simpleMessage("名称"),
    "accountLabelType" : MessageLookupByLibrary.simpleMessage("类型"),
    "accountTitleAdd" : MessageLookupByLibrary.simpleMessage("新增账户"),
    "accountTitleEdit" : MessageLookupByLibrary.simpleMessage("修改账户"),
    "album" : MessageLookupByLibrary.simpleMessage("从相册中选择"),
    "autoBySystem" : MessageLookupByLibrary.simpleMessage("跟随系统"),
    "clickToExit" : MessageLookupByLibrary.simpleMessage("再点击一次退出应用"),
    "dateDay" : MessageLookupByLibrary.simpleMessage("日"),
    "dateMonth" : MessageLookupByLibrary.simpleMessage("月"),
    "dateYear" : MessageLookupByLibrary.simpleMessage("年"),
    "detailHintAccount" : MessageLookupByLibrary.simpleMessage("请先创建账户"),
    "detailHintAmount" : MessageLookupByLibrary.simpleMessage("请输入金额（必填）"),
    "detailHintAmountAccuracy" : MessageLookupByLibrary.simpleMessage("金额只能精确到小数点后两位"),
    "detailHintAmountNone" : MessageLookupByLibrary.simpleMessage("金额不能为空"),
    "detailHintRemark" : MessageLookupByLibrary.simpleMessage("请输入备注（可选）"),
    "detailHintSubject" : MessageLookupByLibrary.simpleMessage("请先创建科目"),
    "detailLabelAmount" : MessageLookupByLibrary.simpleMessage("金额"),
    "detailLabelDate" : MessageLookupByLibrary.simpleMessage("日期"),
    "detailLabelDestAccount" : MessageLookupByLibrary.simpleMessage("目标账户"),
    "detailLabelRemark" : MessageLookupByLibrary.simpleMessage("备注"),
    "detailLabelSourceAccount" : MessageLookupByLibrary.simpleMessage("来源账户"),
    "detailLabelSubject" : MessageLookupByLibrary.simpleMessage("科目"),
    "detailTitleAdd" : MessageLookupByLibrary.simpleMessage("新增明细"),
    "detailTitleEdit" : MessageLookupByLibrary.simpleMessage("修改明细"),
    "empty" : MessageLookupByLibrary.simpleMessage("无数据~"),
    "error" : MessageLookupByLibrary.simpleMessage("请求错误，请重试"),
    "errorNetwork" : MessageLookupByLibrary.simpleMessage("网络连接错误，请检查后再重试~"),
    "hintAdd" : MessageLookupByLibrary.simpleMessage("添加"),
    "hintCancel" : MessageLookupByLibrary.simpleMessage("取消"),
    "hintClickMore" : MessageLookupByLibrary.simpleMessage("再点击%s次"),
    "hintDelete" : MessageLookupByLibrary.simpleMessage("删除"),
    "hintDeleteDialogTitle" : MessageLookupByLibrary.simpleMessage("是否确认删除"),
    "hintDeleteFail" : MessageLookupByLibrary.simpleMessage("删除失败"),
    "hintNo" : MessageLookupByLibrary.simpleMessage("否"),
    "hintYes" : MessageLookupByLibrary.simpleMessage("是"),
    "ipModifyEditHint" : MessageLookupByLibrary.simpleMessage("例：http://172.0.0.1:44444/"),
    "ipModifyTitle" : MessageLookupByLibrary.simpleMessage("设置IP地址全局替换"),
    "loading" : MessageLookupByLibrary.simpleMessage("加载中..."),
    "none" : MessageLookupByLibrary.simpleMessage("无"),
    "settingFont" : MessageLookupByLibrary.simpleMessage("字体切换"),
    "settingLanguage" : MessageLookupByLibrary.simpleMessage("语言切换"),
    "settingTheme" : MessageLookupByLibrary.simpleMessage("主题切换"),
    "subjectHintDesc" : MessageLookupByLibrary.simpleMessage("请输入描述（可选）"),
    "subjectHintName" : MessageLookupByLibrary.simpleMessage("请输入名称（必填）"),
    "subjectHintNameNone" : MessageLookupByLibrary.simpleMessage("名称不能为空"),
    "subjectHintTags" : MessageLookupByLibrary.simpleMessage("请输入标签（必填）"),
    "subjectHintTagsNone" : MessageLookupByLibrary.simpleMessage("标签不能为空"),
    "subjectLabelDesc" : MessageLookupByLibrary.simpleMessage("描述"),
    "subjectLabelName" : MessageLookupByLibrary.simpleMessage("名称"),
    "subjectLabelTags" : MessageLookupByLibrary.simpleMessage("标签"),
    "subjectTitleAdd" : MessageLookupByLibrary.simpleMessage("新增科目"),
    "subjectTitleEdit" : MessageLookupByLibrary.simpleMessage("修改科目"),
    "takePhoto" : MessageLookupByLibrary.simpleMessage("拍照"),
    "titleAccount" : MessageLookupByLibrary.simpleMessage("账户"),
    "titleDetail" : MessageLookupByLibrary.simpleMessage("明细"),
    "titleSetting" : MessageLookupByLibrary.simpleMessage("设置"),
    "titleSubject" : MessageLookupByLibrary.simpleMessage("科目"),
    "userNickname" : MessageLookupByLibrary.simpleMessage("记账"),
    "userNicknameHint" : MessageLookupByLibrary.simpleMessage("昵称"),
    "userTitle" : MessageLookupByLibrary.simpleMessage("个人信息设置")
  };
}
