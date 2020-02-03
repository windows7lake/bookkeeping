import 'dart:convert' show json;

typedef Success<T> = void Function(String msg, T data);
typedef Error = void Function(String msg);

/// 请求返回值（普通请求）
class Response<T> {
  int code;
  String msg;
  T data;

  /// 使用factory constructor来替代overload
  factory Response(
      jsonStr, // json 字符串
      Function buildFun, // 将字符串转为对象的方法
      {Success<T> onSuccess,
      Error onError}) {
    return jsonStr is String
        ? Response.fromJson(json.decode(jsonStr), buildFun, onSuccess, onError)
        : Response.fromJson(jsonStr, buildFun, onSuccess, onError);
  }

  /// 数据解析以及回调处理<br>
  /// @param json ：待解析的json字符串<br>
  /// @param fun ：用于解析json数据的函数<br>
  /// @param onSuccess ：请求成功回调（code == 200）<br>
  /// @param onError ：请求失败回调（code != 200）<br>
  Response.fromJson(json, Function fun, Success<T> onSuccess, Error onError) {
    if (json == null) {
      if (onError != null) onError("json数据为空，解析失败");
      return;
    }
    code = json["status"];
    msg = json["info"];
    if (code == 200) {
      data = fun(json["data"]);
      if (onSuccess != null) onSuccess(msg, data);
    } else {
      if (onError != null) onError(msg);
    }
  }

  @override
  String toString() {
    return 'Response { code: $code, msg: $msg, data: $data }';
  }
}

/// 请求返回值 无data （普通请求）
class ResponseRaw {
  int code;
  String msg;

  factory ResponseRaw(jsonStr, {Success onSuccess, Error onError}) =>
      jsonStr is String
          ? ResponseRaw.fromJson(json.decode(jsonStr), onSuccess, onError)
          : ResponseRaw.fromJson(jsonStr, onSuccess, onError);

  /// 数据解析以及回调处理<br>
  /// @param json ：待解析的json字符串<br>
  /// @param onSuccess ：请求成功回调（code == 200）<br>
  /// @param onError ：请求失败回调（code != 200）<br>
  ResponseRaw.fromJson(json, Success onSuccess, Error onError) {
    if (json == null) {
      if (onError != null) onError("json数据为空，解析失败");
      return;
    }
    code = json["status"];
    msg = json["info"];
    if (code == 200) {
      if (onSuccess != null) onSuccess(msg, null);
    } else if (onError != null) {
      onError(msg);
    }
  }

  @override
  String toString() {
    return 'Response { code: $code, msg: $msg }';
  }
}

/// 请求返回值 List（普通请求）
class ResponseList<T> {
  int code;
  String msg;
  List<T> data;

  factory ResponseList(
    jsonStr,
    Function buildFun, {
    Success<List<T>> onSuccess,
    Error onError,
  }) {
    return jsonStr is String
        ? ResponseList.fromJson(
            json.decode(jsonStr), buildFun, onSuccess, onError)
        : ResponseList.fromJson(jsonStr, buildFun, onSuccess, onError);
  }

  /// 数据解析以及回调处理<br>
  /// @param json ：待解析的json字符串<br>
  /// @param fun ：用于解析json数据的函数<br>
  /// @param onSuccess ：请求成功回调（code == 200）<br>
  /// @param onError ：请求失败回调（code != 200）<br>
  ResponseList.fromJson(
      json, Function fun, Success<List<T>> onSuccess, Error onError) {
    if (json == null) {
      if (onError != null) onError("json数据为空，解析失败");
      return;
    }
    code = json["status"];
    msg = json["info"];
    if (code == 200) {
      data = new List<T>();
      json["data"]?.forEach((v) {
        data.add(fun(v));
      });
      if (onSuccess != null) onSuccess(msg, data);
    } else {
      if (onError != null) onError(msg);
    }
  }

  @override
  String toString() {
    return 'Response { code: $code, msg: $msg, data: $data }';
  }
}

/// 请求返回值（restful请求）
class ResponseREST<T> {
  int statusCode;
  int code;
  String msg;
  T data;

  factory ResponseREST(jsonStr, Function buildFun, {Success<T> onSuccess}) {
    return jsonStr is String
        ? ResponseREST.fromJson(json.decode(jsonStr), buildFun, onSuccess)
        : ResponseREST.fromJson(jsonStr, buildFun, onSuccess);
  }

  /// 数据解析以及回调处理<br>
  /// @param json ：待解析的json字符串<br>
  /// @param fun ：用于解析json数据的函数<br>
  /// @param onResponse ：请求回调<br>
  ResponseREST.fromJson(json, Function fun, Success<T> onSuccess) {
    statusCode = json["status_code"];
    code = json["code"];
    msg = json["message"];
    data = fun(json["data"]);
    if (onSuccess != null) onSuccess(msg, data);
  }

  @override
  String toString() {
    return 'ResponseREST { data: $data }';
  }
}
