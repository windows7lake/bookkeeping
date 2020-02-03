import 'package:bookkeeping/cache/db/db_manager.dart';
import 'package:bookkeeping/cache/sp/sp_manager.dart';
import 'package:bookkeeping/cache/sp/sp_params.dart';
import 'package:bookkeeping/pages/subject/subject_skeleton.dart';
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
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        child: initPage(),
      ),
      localizationsDelegates: const [
//        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
//      supportedLocales: S.delegate.supportedLocales,
      navigatorObservers: [RouteManager.instance],
      routes: RouteManager.configRoutes,
    );
  }

  ChangeNotifierProvider initPage() {
    if (SpManager.getBool(SpParams.firstLoad, defaultValue: true))
      return ProviderConfig.instance.userPage;
    return ProviderConfig.instance.homePage;
  }
}
