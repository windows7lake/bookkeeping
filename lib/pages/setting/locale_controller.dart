import 'package:bookkeeping/cache/sp/sp_manager.dart';
import 'package:bookkeeping/cache/sp/sp_params.dart';
import 'package:bookkeeping/l10n/intl_localizations.dart';
import 'package:bookkeeping/pages/setting/locale_mode.dart';
import 'package:bookkeeping/provider/base_controller.dart';
import 'package:flutter/material.dart';

class LocaleController extends BaseController<LocaleModel> {
  LocaleController() {
    model = LocaleModel();
  }

  void init() {
    model.localeIndex = SpManager.getInt(SpParams.localeIndex);
  }

  /// 获取当前所选的语言
  Locale get locale {
    if (model.localeIndex > 0) {
      var value = model.localeValueList[model.localeIndex].split("-");
      return Locale(value[0], value.length == 2 ? value[1] : '');
    }
    // 跟随系统
    return null;
  }

  /// 切换语言
  switchLocale(int index) {
    model.localeIndex = index;
    notifyListeners();
    SpManager.setInt(SpParams.localeIndex, index);
  }

  /// 获取当前所选的语言字符
  static String localeName(index, context) {
    switch (index) {
      case 0:
        return IntlLocalizations.of(context).autoBySystem;
      case 1:
        return '中文';
      case 2:
        return 'English';
      default:
        return '';
    }
  }
}
