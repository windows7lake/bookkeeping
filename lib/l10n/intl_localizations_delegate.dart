import 'package:bookkeeping/l10n/intl_localizations.dart';
import 'package:flutter/material.dart';

class IntlLocalizationsDelegate
    extends LocalizationsDelegate<IntlLocalizations> {
  @override
  Future<IntlLocalizations> load(Locale locale) {
    return IntlLocalizations.load(locale);
  }

  @override
  bool isSupported(Locale locale) =>
      ['zh', 'en'].contains(locale.languageCode); // 支持的类型要包含App中注册的类型

  @override
  bool shouldReload(IntlLocalizationsDelegate old) => false;
}
