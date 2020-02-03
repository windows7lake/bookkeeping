import 'dart:async';

import 'package:bookkeeping/cache/sp/sp_manager.dart';
import 'package:bookkeeping/cache/sp/sp_params.dart';
import 'package:bookkeeping/network/api/api.dart';
import 'package:bookkeeping/util/const_ext.dart';
import 'package:dio/dio.dart';

class HeaderInterceptor extends InterceptorsWrapper {
  /// 获取网络请求URL <br/>
  static Future<String> getBaseUrl() async {
    String url = Api.RELEASE;
    if (isDebug) url = Api.DEBUG;
    int value = 1; //+ await Global.instance.getApiEnv();
    switch (value) {
      case 0:
        url = Api.RELEASE;
        break;
      case 1:
        url = Api.DEBUG;
        break;
        break;
    }
    String tempUrl = SpManager.getString(SpParams.url);
    if (tempUrl.isNotEmpty) url = tempUrl;
    return url;
  }

  /// 添加Header拦截器 <br/>
  addHeaderInterceptors(RequestOptions options) async {
//    if (UserInfoManager.instance.accessToken.isNotEmpty) {
//      options.headers["Authorization"] =
//          "Bearer " + UserInfoManager.instance.accessToken;
//    } else {
//      options.headers.remove("Authorization");
//    }
  }

  @override
  Future onRequest(RequestOptions options) async {
    String url = await getBaseUrl();
    options.baseUrl = url;
//    options.headers["User-Agent"] =
//        "version/${AppInfoManager.instance.version}" +
//            " version_code/${AppInfoManager.instance.versionCode}" +
//            " clients/${AppInfoManager.instance.platform}" +
//            " imei/${AppInfoManager.instance.imei}" +
//            " model/${AppInfoManager.instance.mode}";
    addHeaderInterceptors(options);
    return options;
  }
}
