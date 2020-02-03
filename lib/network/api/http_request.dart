import 'dart:collection';
import 'dart:convert';

import 'package:bookkeeping/network/interceptor/header_interceptor.dart';
import 'package:bookkeeping/network/interceptor/log_interceptor.dart';
import 'package:bookkeeping/util/log_ext.dart';
import 'package:bookkeeping/util/toast_ext.dart';
import 'package:dio/dio.dart';

import 'api.dart';

/// 可支持 restful 请求和普通API请求
///
/// GET、POST、DELETE、PATCH、PUT <br>
/// 主要作用为统一处理相关事务：<br>
///  - 统一处理请求前缀；<br>
///  - 统一打印请求信息；<br>
///  - 统一打印响应信息；<br>
///  - 统一打印报错信息；
class HttpRequest {
  static HttpRequest _instance;

  static final String baseUrl = Api.RELEASE;

  static const int connectTimeOut = 10 * 1000; // 连接超时时间为10秒
  static const int receiveTimeOut = 15 * 1000; // 响应超时时间为15秒

  /// 请求方式
  static const String GET = "get";
  static const String POST = "post";
  static const String PUT = 'put';
  static const String PATCH = 'patch';
  static const String DELETE = 'delete';

  static HttpRequest getInstance() {
    if (_instance == null) {
      _instance = HttpRequest._internal();
    }
    return _instance;
  }

  Dio _client;

  Dio get client => _client;

  HttpRequest._internal() {
    if (_client == null) {
      BaseOptions options = new BaseOptions();
      options.connectTimeout = connectTimeOut;
      options.receiveTimeout = receiveTimeOut;
      options.baseUrl = baseUrl;

      _client = new Dio(options);
      _client.interceptors.add(HeaderInterceptor());
      _client.interceptors.add(LogPrintInterceptor(
        request: true,
        requestHeader: true,
        responseHeader: false,
        responseBody: true,
      )); // 开启请求日志
    }
  }

  /// Get请求 <br/>
  ///
  /// @param [url] 请求地址 <br/>
  /// @param [params] 请求参数（可选） <br/>
  /// @param [callBack] 请求结果回调方法（可选） <br/>
  /// @param [errorCallBack] 出错回调（可选） <br/>
  /// @param [commonCallBack] 公共回调方法，成功和失败都会调用（可选） <br/>
  /// @param [token] 取消请求时使用的CancelToken（可选） <br/>
  void get(
    String url, {
    Map<String, dynamic> params,
    Function callBack,
    Function errorCallBack,
    Function commonCallBack,
    CancelToken token,
  }) async {
    _request(
      url,
      method: GET,
      params: params,
      callBack: callBack,
      errorCallBack: errorCallBack,
      commonCallBack: commonCallBack,
      token: token,
    );
  }

  /// Post请求 <br/>
  ///
  /// @param [url] 请求地址 <br/>
  /// @param [params] 请求参数（可选） <br/>
  /// @param [callBack] 请求结果回调方法（可选） <br/>
  /// @param [errorCallBack] 出错回调（可选） <br/>
  /// @param [commonCallBack] 公共回调方法，成功和失败都会调用（可选） <br/>
  /// @param [token] 取消请求时使用的CancelToken（可选） <br/>
  void post(
    String url, {
    Map<String, dynamic> params,
    Map<String, dynamic> formData,
    Map<String, dynamic> rawData,
    Function callBack,
    Function errorCallBack,
    Function commonCallBack,
    CancelToken token,
  }) async {
    _request(
      url,
      method: POST,
      params: params,
      formData: formData,
      rawData: rawData,
      callBack: callBack,
      errorCallBack: errorCallBack,
      commonCallBack: commonCallBack,
      token: token,
    );
  }

  /// DELETE请求 <br/>
  ///
  /// @param [url] 请求地址 <br/>
  /// @param [params] 请求参数（可选） <br/>
  /// @param [callBack] 请求结果回调方法（可选） <br/>
  /// @param [errorCallBack] 出错回调（可选） <br/>
  /// @param [commonCallBack] 公共回调方法，成功和失败都会调用（可选） <br/>
  /// @param [token] 取消请求时使用的CancelToken（可选） <br/>
  void delete(
    String url, {
    Map<String, dynamic> params,
    Function callBack,
    Function errorCallBack,
    Function commonCallBack,
    CancelToken token,
  }) async {
    _request(
      url,
      method: DELETE,
      params: params,
      callBack: callBack,
      errorCallBack: errorCallBack,
      commonCallBack: commonCallBack,
      token: token,
    );
  }

  /// Put上传 <br/>
  ///
  /// @param [url] 请求地址 <br/>
  /// @param [formData] 请求form表单数据（可选） <br/>
  /// @param [callBack] 请求结果回调方法（可选） <br/>
  /// @param [errorCallBack] 出错回调（可选） <br/>
  /// @param [commonCallBack] 公共回调方法，成功和失败都会调用（可选） <br/>
  /// @param [progressCallBack] 请求进度回调方法 <br/>
  /// @param [onReceiveProgress] 接收进度回调方法 <br/>
  /// @param [token] 取消请求时使用的CancelToken（可选） <br/>
  void put(
    String url, {
    Map<String, dynamic> params,
    Function callBack,
    Function errorCallBack,
    Function commonCallBack,
    ProgressCallback progressCallBack,
    ProgressCallback onReceiveProgress,
    CancelToken token,
  }) async {
    _request(
      url,
      method: PUT,
      params: params,
      callBack: callBack,
      errorCallBack: errorCallBack,
      commonCallBack: commonCallBack,
      progressCallBack: progressCallBack,
      onReceiveProgress: onReceiveProgress,
      token: token,
    );
  }

  /// Post上传 <br/>
  ///
  /// @param [url] 请求地址 <br/>
  /// @param [formData] 请求form表单数据（可选） <br/>
  /// @param [callBack] 请求结果回调方法（可选） <br/>
  /// @param [errorCallBack] 出错回调（可选） <br/>
  /// @param [commonCallBack] 公共回调方法，成功和失败都会调用（可选） <br/>
  /// @param [progressCallBack] 请求进度回调方法 <br/>
  /// @param [token] 取消请求时使用的CancelToken（可选） <br/>
  void postUpload(
    String url, {
    Map<String, dynamic> formData,
    Function callBack,
    Function errorCallBack,
    Function commonCallBack,
    ProgressCallback progressCallBack,
    CancelToken token,
  }) async {
    _request(
      url,
      method: POST,
      formData: formData,
      callBack: callBack,
      errorCallBack: errorCallBack,
      commonCallBack: commonCallBack,
      progressCallBack: progressCallBack,
      token: token,
    );
  }

  /// 统一请求方法 <br/>
  ///
  /// @param [url] 请求地址 <br/>
  /// @param [method] 请求方式：GET、POST、DELETE、PATCH、PUT（可选）<br/>
  /// @param [params] 请求参数（可选） <br/>
  /// @param [formData] 请求form表单数据（可选） <br/>
  /// @param [callBack] 请求结果回调方法（可选） <br/>
  /// @param [errorCallBack] 出错回调（可选） <br/>
  /// @param [commonCallBack] 公共回调方法，成功和失败都会调用（可选） <br/>
  /// @param [progressCallBack] 请求进度回调方法（可选） <br/>
  /// @param [token] 取消请求时使用的CancelToken（可选） <br/>
  void _request(
    String url, {
    String method,
    Map<String, dynamic> params,
    Map<String, dynamic> formData,
    Map<String, dynamic> rawData,
    Function callBack,
    Function errorCallBack,
    Function commonCallBack,
    ProgressCallback progressCallBack,
    ProgressCallback onReceiveProgress,
    CancelToken token,
  }) async {
    // restful api 格式化处理
    // 例：将 /user/:userId 转换为 /user/12
    Map<String, dynamic> newParams = HashMap<String, dynamic>();
    params = params ?? {};
    params.forEach((key, value) {
      if (url.indexOf(key) != -1) {
        url = url.replaceAll(':$key', value.toString());
      } else {
        newParams.putIfAbsent(key, () => value);
      }
    });

    try {
      Response response;
      switch (method) {
        case GET:
          // 组合GET请求的参数
          if (newParams != null && newParams.isNotEmpty) {
            response = await _client.get(
              url,
              queryParameters: newParams,
              cancelToken: token,
            );
          } else {
            response = await _client.get(
              url,
              cancelToken: token,
            );
          }
          break;
        case POST:
          if (newParams != null && newParams.isNotEmpty) {
            response = await _client.post(
              url,
              data: newParams,
              options: Options(
                contentType: "application/x-www-form-urlencoded",
              ),
              onSendProgress: progressCallBack,
              cancelToken: token,
            );
          } else if (formData != null && formData.isNotEmpty) {
            response = await _client.post(
              url,
              data: FormData.fromMap(formData),
              onSendProgress: progressCallBack,
              cancelToken: token,
            );
          } else if (rawData != null && rawData.isNotEmpty) {
            response = await _client.post(
              url,
              data: json.encode(rawData),
              options: Options(contentType: "application/json"),
              onSendProgress: progressCallBack,
              cancelToken: token,
            );
          } else {
            response = await _client.post(
              url,
              cancelToken: token,
            );
          }
          break;
        case DELETE:
          if (newParams != null && newParams.isNotEmpty) {
            response = await _client.delete(
              url,
              queryParameters: newParams,
              cancelToken: token,
            );
          } else {
            response = await _client.delete(
              url,
              cancelToken: token,
            );
          }
          break;
        case PUT:
          if (newParams != null && newParams.isNotEmpty) {
            response = await _client.put(
              url,
              queryParameters: newParams,
              cancelToken: token,
            );
          } else {
            response = await _client.put(
              url,
              cancelToken: token,
            );
          }
          break;
      }

      // 请求回调公共处理方法
      if (commonCallBack != null) commonCallBack();
      // 请求成功的回调
      if (callBack != null) callBack(response.data);
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) print('网络请求取消：' + e.message);

      // 请求回调公共处理方法
      if (commonCallBack != null) commonCallBack();
      _handleError(errorCallBack, error: e);
    }
  }

  /// 异常处理<br/>
  ///
  /// @param [errorCallback] 错误处理回调方法 <br/>
  /// @param [error] DioError由dio封装的错误信息（可选） <br/>
  /// @param [errorMsg] 出错信息（可选） <br/>
  static void _handleError(Function errorCallback,
      {DioError error, String errorMsg}) {
    String errorDescription = "";
    String errorOutput = "";
    if (error is DioError) {
      switch (error.type) {
        case DioErrorType.DEFAULT:
          errorDescription = error.message;
          errorOutput = "请求错误";
          break;
        case DioErrorType.CANCEL:
          errorDescription = "请求被取消";
          errorOutput = "请求取消";
          break;
        case DioErrorType.CONNECT_TIMEOUT:
          errorDescription = "连接服务器超时";
          errorOutput = "连接服务器超时";
          break;
        case DioErrorType.SEND_TIMEOUT:
          errorDescription = "请求服务器超时";
          errorOutput = "请求服务器超时";
          break;
        case DioErrorType.RECEIVE_TIMEOUT:
          errorDescription = "服务器响应超时";
          errorOutput = "服务器响应超时";
          break;
        case DioErrorType.RESPONSE:
          errorDescription = "状态码: " +
              "${error.response.statusCode}  出错信息: ${error.response.statusMessage}";
          errorOutput = "请求错误";
          break;
      }
    } else if (errorMsg.isNotEmpty) {
      errorDescription = errorMsg;
      errorOutput = "请求错误";
    } else {
      errorDescription = "未知错误";
      errorOutput = "未知错误";
    }

    LogExt.log("错误原因 " + errorDescription);
    if (errorCallback != null) {
      errorCallback(error);
    } else {
      ToastExt.show(errorOutput);
    }
  }
}
