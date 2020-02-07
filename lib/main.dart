import 'package:bookkeeping/cache/db/db_manager.dart';
import 'package:bookkeeping/cache/sp/sp_manager.dart';
import 'package:bookkeeping/cache/sp/sp_params.dart';
import 'package:bookkeeping/l10n/intl_localizations_delegate.dart';
import 'package:bookkeeping/pages/setting/locale_controller.dart';
import 'package:bookkeeping/pages/setting/theme_controller.dart';
import 'package:bookkeeping/provider/provider_config.dart';
import 'package:bookkeeping/routes/route_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  // 存储相关配置项初始化
  await SpManager.getInstance();
  await DBManager.getDatabase();
  runApp(ProviderConfig.instance.getGlobal(MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeController, LocaleController>(
        builder: (_, themeController, localeController, child) {
      return MaterialApp(
        theme: themeController.themeData(),
        darkTheme: themeController.themeData(platformDarkMode: true),
        locale: localeController.locale,
        localizationsDelegates: [
          IntlLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          // 支持的语言类型
          const Locale('zh', ''),
          const Locale('en', 'US'), // English
        ],
        navigatorObservers: [RouteManager.instance],
        routes: RouteManager.configRoutes,
        home: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
          ),
          child: initPage(),
        ),
      );
    });
  }

  ChangeNotifierProvider initPage() {
    if (SpManager.getBool(SpParams.firstLoad, defaultValue: true))
      return ProviderConfig.instance.userPage;
    return ProviderConfig.instance.homePage;
  }
}
