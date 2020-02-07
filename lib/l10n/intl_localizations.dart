import 'package:bookkeeping/l10n/messages_all.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IntlLocalizations {
  final String localeName;

  IntlLocalizations(this.localeName);

  static Future<IntlLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      return IntlLocalizations(localeName);
    });
  }

  static IntlLocalizations of(BuildContext context) {
    return Localizations.of<IntlLocalizations>(context, IntlLocalizations);
  }

  /// =================================
  /// ========== 公共提示内容 ==========
  /// =================================
  String get clickToExit => Intl.message(
        '再点击一次退出应用',
        name: 'clickToExit',
        desc: '提示-clickToExit',
        locale: localeName,
      );

  String get none => Intl.message(
        '无',
        name: 'none',
        desc: '提示-none',
        locale: localeName,
      );

  String get autoBySystem => Intl.message(
        '跟随系统',
        name: 'autoBySystem',
        desc: '标签-跟随系统',
        locale: localeName,
      );

  String get dateYear => Intl.message(
        '年',
        name: 'dateYear',
        desc: '标签-年',
        locale: localeName,
      );

  String get dateMonth => Intl.message(
        '月',
        name: 'dateMonth',
        desc: '标签-月',
        locale: localeName,
      );

  String get dateDay => Intl.message(
        '日',
        name: 'dateDay',
        desc: '标签-日',
        locale: localeName,
      );

  String get hintYes => Intl.message(
        '是',
        name: 'hintYes',
        desc: '提示-是',
        locale: localeName,
      );

  String get hintNo => Intl.message(
        '否',
        name: 'hintNo',
        desc: '提示-否',
        locale: localeName,
      );

  String get hintAdd => Intl.message(
        '添加',
        name: 'hintAdd',
        desc: '提示-添加',
        locale: localeName,
      );

  String get hintDelete => Intl.message(
        '删除',
        name: 'hintDelete',
        desc: '提示-删除',
        locale: localeName,
      );

  String get hintCancel => Intl.message(
        '取消',
        name: 'hintCancel',
        desc: '提示-取消',
        locale: localeName,
      );

  String get hintDeleteFail => Intl.message(
        '删除失败',
        name: 'hintDeleteFail',
        desc: '提示-删除失败',
        locale: localeName,
      );

  String get hintDeleteDialogTitle => Intl.message(
        '是否确认删除',
        name: 'hintDeleteDialogTitle',
        desc: '提示-是否确认删除',
        locale: localeName,
      );

  /// =================================
  /// ============ 用户部分 ============
  /// =================================
  String get ipModifyTitle => Intl.message(
        '设置IP地址全局替换',
        name: 'ipModifyTitle',
        desc: 'IP-标题-设置IP地址全局替换',
        locale: localeName,
      );

  String get ipModifyEditHint => Intl.message(
        '例：http://172.0.0.1:44444/',
        name: 'ipModifyEditHint',
        desc: 'IP-提示-例：http://172.0.0.1:44444/',
        locale: localeName,
      );

  String get userTitle => Intl.message(
        '个人信息设置',
        name: 'userTitle',
        desc: '用户-标题-个人信息设置',
        locale: localeName,
      );

  String get userNicknameHint => Intl.message(
        '昵称',
        name: 'userNicknameHint',
        desc: '用户-提示-昵称',
        locale: localeName,
      );

  String get userNickname => Intl.message(
        '记账',
        name: 'userNickname',
        desc: '用户-提示-记账',
        locale: localeName,
      );

  String get hintClickMore => Intl.message(
        '再点击%s次',
        name: 'hintClickMore',
        desc: '用户-提示-点击',
        locale: localeName,
      );

  /// =================================
  /// ============ 标题部分 ============
  /// =================================
  String get titleDetail => Intl.message(
        '明细',
        name: 'titleDetail',
        desc: '标题-明细',
        locale: localeName,
      );

  String get titleAccount => Intl.message(
        '账户',
        name: 'titleAccount',
        desc: '标题-账户',
        locale: localeName,
      );

  String get titleSubject => Intl.message(
        '科目',
        name: 'titleSubject',
        desc: '标题-科目',
        locale: localeName,
      );

  String get titleSetting => Intl.message(
        '设置',
        name: 'titleSetting',
        desc: '标题-设置',
        locale: localeName,
      );

  /// =================================
  /// ============ 明细部分 ============
  /// =================================
  String get detailTitleAdd => Intl.message(
        '新增明细',
        name: 'detailTitleAdd',
        desc: '明细-标题-新增明细',
        locale: localeName,
      );

  String get detailTitleEdit => Intl.message(
        '修改明细',
        name: 'detailTitleEdit',
        desc: '明细-标题-修改明细',
        locale: localeName,
      );

  String get detailLabelSubject => Intl.message(
        '科目',
        name: 'detailLabelSubject',
        desc: '明细-标签-科目',
        locale: localeName,
      );

  String get detailLabelAmount => Intl.message(
        '金额',
        name: 'detailLabelAmount',
        desc: '明细-标签-金额',
        locale: localeName,
      );

  String get detailLabelSourceAccount => Intl.message(
        '来源账户',
        name: 'detailLabelSourceAccount',
        desc: '明细-标签-来源账户',
        locale: localeName,
      );

  String get detailLabelDestAccount => Intl.message(
        '目标账户',
        name: 'detailLabelDestAccount',
        desc: '明细-标签-目标账户',
        locale: localeName,
      );

  String get detailLabelDate => Intl.message(
        '日期',
        name: 'detailLabelDate',
        desc: '明细-标签-日期',
        locale: localeName,
      );

  String get detailLabelRemark => Intl.message(
        '备注',
        name: 'detailLabelRemark',
        desc: '明细-标签-备注',
        locale: localeName,
      );

  String get detailHintAccount => Intl.message(
        '请先创建账户',
        name: 'detailHintAccount',
        desc: '明细-提示-账户',
        locale: localeName,
      );

  String get detailHintSubject => Intl.message(
        '请先创建科目',
        name: 'detailHintSubject',
        desc: '明细-提示-科目',
        locale: localeName,
      );

  String get detailHintAmount => Intl.message(
        '请输入金额（必填）',
        name: 'detailHintAmount',
        desc: '明细-提示-金额',
        locale: localeName,
      );

  String get detailHintAmountNone => Intl.message(
        '金额不能为空',
        name: 'detailHintAmountNone',
        desc: '明细-提示-金额不能为空',
        locale: localeName,
      );

  String get detailHintAmountAccuracy => Intl.message(
        '金额只能精确到小数点后两位',
        name: 'detailHintAmountAccuracy',
        desc: '明细-提示-金额精确度',
        locale: localeName,
      );

  String get detailHintRemark => Intl.message(
        '请输入备注（可选）',
        name: 'detailHintRemark',
        desc: '明细-提示-备注',
        locale: localeName,
      );

  /// =================================
  /// ============ 账户部分 ============
  /// =================================
  String get accountTitleAdd => Intl.message(
        '新增账户',
        name: 'accountTitleAdd',
        desc: '账户-标题-新增账户',
        locale: localeName,
      );

  String get accountTitleEdit => Intl.message(
        '修改账户',
        name: 'accountTitleEdit',
        desc: '账户-标题-修改账户',
        locale: localeName,
      );

  String get accountLabelType => Intl.message(
        '类型',
        name: 'accountLabelType',
        desc: '账户-标签-类型',
        locale: localeName,
      );

  String get accountLabelName => Intl.message(
        '名称',
        name: 'accountLabelName',
        desc: '账户-标签-名称',
        locale: localeName,
      );

  String get accountLabelDesc => Intl.message(
        '描述',
        name: 'accountLabelDesc',
        desc: '账户-标签-描述',
        locale: localeName,
      );

  String get accountHintType => Intl.message(
        '请输入类型（必填）',
        name: 'accountHintType',
        desc: '账户-提示-类型',
        locale: localeName,
      );

  String get accountHintTypeNone => Intl.message(
        '类型不能为空',
        name: 'accountHintTypeNone',
        desc: '账户-提示-类型',
        locale: localeName,
      );

  String get accountHintName => Intl.message(
        '请输入名称（必填）',
        name: 'accountHintName',
        desc: '账户-提示-名称',
        locale: localeName,
      );

  String get accountHintNameNone => Intl.message(
        '名称不能为空',
        name: 'accountHintNameNone',
        desc: '账户-提示-名称',
        locale: localeName,
      );

  String get accountHintDesc => Intl.message(
        '请输入描述（可选）',
        name: 'accountHintDesc',
        desc: '账户-提示-描述',
        locale: localeName,
      );

  /// =================================
  /// ============ 科目部分 ============
  /// =================================
  String get subjectTitleAdd => Intl.message(
        '新增科目',
        name: 'subjectTitleAdd',
        desc: '科目-标题-新增科目',
        locale: localeName,
      );

  String get subjectTitleEdit => Intl.message(
        '修改科目',
        name: 'subjectTitleEdit',
        desc: '科目-标题-修改科目',
        locale: localeName,
      );

  String get subjectLabelTags => Intl.message(
        '标签',
        name: 'subjectLabelTags',
        desc: '科目-标签-标签',
        locale: localeName,
      );

  String get subjectLabelName => Intl.message(
        '名称',
        name: 'subjectLabelName',
        desc: '科目-标签-名称',
        locale: localeName,
      );

  String get subjectLabelDesc => Intl.message(
        '描述',
        name: 'subjectLabelDesc',
        desc: '科目-标签-描述',
        locale: localeName,
      );

  String get subjectHintTags => Intl.message(
        '请输入标签（必填）',
        name: 'subjectHintTags',
        desc: '科目-提示-标签',
        locale: localeName,
      );

  String get subjectHintName => Intl.message(
        '请输入名称（必填）',
        name: 'subjectHintName',
        desc: '科目-提示-名称',
        locale: localeName,
      );

  String get subjectHintDesc => Intl.message(
        '请输入描述（可选）',
        name: 'subjectHintDesc',
        desc: '科目-提示-描述',
        locale: localeName,
      );

  String get subjectHintTagsNone => Intl.message(
        '标签不能为空',
        name: 'subjectHintTagsNone',
        desc: '科目-提示-标签',
        locale: localeName,
      );

  String get subjectHintNameNone => Intl.message(
        '名称不能为空',
        name: 'subjectHintNameNone',
        desc: '科目-提示-名称',
        locale: localeName,
      );

  /// =================================
  /// ============ 设置部分 ============
  /// =================================
  String get settingFont => Intl.message(
        '字体切换',
        name: 'settingFont',
        desc: '设置-标签-字体切换',
        locale: localeName,
      );

  String get settingLanguage => Intl.message(
        '语言切换',
        name: 'settingLanguage',
        desc: '设置-标签-语言切换',
        locale: localeName,
      );

  String get settingTheme => Intl.message(
        '主题切换',
        name: 'settingTheme',
        desc: '设置-标签-主题切换',
        locale: localeName,
      );

  /// =================================
  /// =========== Widget部分 ===========
  /// =================================
  String get takePhoto => Intl.message(
        '拍照',
        name: 'takePhoto',
        desc: '拍照',
        locale: localeName,
      );

  String get album => Intl.message(
        '从相册中选择',
        name: 'album',
        desc: '从相册中选择',
        locale: localeName,
      );

  String get loading => Intl.message(
        '加载中...',
        name: 'loading',
        desc: '加载中',
        locale: localeName,
      );

  String get empty => Intl.message(
        '无数据~',
        name: 'empty',
        desc: '无数据',
        locale: localeName,
      );

  String get error => Intl.message(
        '请求错误，请重试',
        name: 'error',
        desc: '请求错误',
        locale: localeName,
      );

  String get errorNetwork => Intl.message(
        '网络连接错误，请检查后再重试~',
        name: 'errorNetwork',
        desc: '网络连接错误',
        locale: localeName,
      );
}
