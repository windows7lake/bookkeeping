import 'dart:async';

import 'package:dio/dio.dart';

/// [LogPrintInterceptor] is used to print logs during network requests.
/// It's better to add [LogPrintInterceptor] to the tail of the interceptor queue,
/// otherwise the changes made in the interceptor behind A will not be printed out.
/// This is because the execution of interceptors is in the order of addition.
class LogPrintInterceptor extends Interceptor {
  LogPrintInterceptor({
    this.request = true,
    this.requestHeader = true,
    this.requestBody = false,
    this.responseHeader = true,
    this.responseBody = false,
    this.error = true,
    this.logPrint = print,
  });

  /// Print request [Options]
  bool request;

  /// Print request header [Options.headers]
  bool requestHeader;

  /// Print request data [Options.data]
  bool requestBody;

  /// Print [Response.data]
  bool responseBody;

  /// Print [Response.headers]
  bool responseHeader;

  /// Print error message
  bool error;

  /// Log printer; defaults print log to console.
  /// In flutter, you'd better use debugPrint.
  /// you can also write log in a file, for example:
  ///```dart
  ///  var file=File("./log.txt");
  ///  var sink=file.openWrite();
  ///  dio.interceptors.add(LogPrintInterceptor(logPrint: sink.writeln));
  ///  ...
  ///  await sink.close();
  ///```
  void Function(Object object) logPrint;

  @override
  Future onRequest(RequestOptions options) async {
    logPrint('*************** 请求发起 ***************');
    printKV('请求链接', options.uri);

    if (request) {
      printKV('请求方式', options.method);
      if (options.method == "POST") {
        if (options.data is FormData) {
          StringBuffer sb = StringBuffer();
          sb.write("{");
          (options.data as FormData).fields.forEach((e) {
            sb.write("${e.key}: ${e.value}, ");
          });
          sb.write("}");
          printKV('请求参数', sb.toString());
        } else {
          printKV('请求参数', options.data);
        }
      } else {
        printKV('请求参数', options.queryParameters);
      }
    }
    if (requestHeader) {
      StringBuffer stringBuffer = StringBuffer();
      options.headers.forEach((key, v) => stringBuffer.write('\n  $key:$v'));
      printKV('请求头部', stringBuffer.toString());
      stringBuffer.clear();
    }
    if (requestBody) {
      logPrint("data:");
      printAll(options.data);
    }
    logPrint("");
  }

  @override
  Future onError(DioError err) async {
    if (error) {
      logPrint('*************** 请求出错 ***************:');
      logPrint("出错链接: ${err.request.uri}");
      logPrint("$err");
      if (err.response != null) {
        _printResponse(err.response);
      }
      logPrint("");
    }
  }

  @override
  Future onResponse(Response response) async {
    logPrint("*************** 请求响应 ***************");
    _printResponse(response);
  }

  void _printResponse(Response response) {
    printKV('响应链接', response.request?.uri);
    if (responseHeader) {
      printKV('响应状态码', response.statusCode);
      if (response.isRedirect == true) {
        printKV('redirect', response.realUri);
      }
      if (response.headers != null) {
        logPrint("响应头部:");
        var headers = response.headers.toString()?.replaceAll("\n", "\n ");
        if (headers != null) {
          logPrint(" $headers");
        }
      }
    }
    if (responseBody) {
      logPrint("响应内容:");
      printAll(response.toString());
    }
    logPrint("");
  }

  printKV(String key, Object v) {
    logPrint('$key: $v');
  }

  /// 打印Json格式化数据
  printAll(msg) {
    String prettyPrint = msg
        .toString()
        .replaceAll(",\"", ",\n\"")
        .replaceAll(",{", ",\n{")
        .replaceAll(",[", ",\n[")
        .replaceAll(":{", ":\n{")
        .replaceAll("},", "},\n \n")
        .replaceAll("[", "\n       [\n")
        .replaceAll("]", "\n       ]\n");
    if (prettyPrint.length < 800) {
      logPrint(prettyPrint);
      return;
    }
    prettyPrint.split("\n").forEach((text) {
      logPrint("$text");
    });
  }
}
