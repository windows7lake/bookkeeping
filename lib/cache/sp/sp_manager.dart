import 'package:bookkeeping/cache/sp/sp_params.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';

/// 偏好设置存储管理类
class SpManager {
  static SpManager _singleton;
  static Lock _lock = Lock();
  static SharedPreferences _sharedPreferences;

  static Future<SpManager> getInstance() async {
    if (_singleton == null) {
      await _lock.synchronized(() async {
        if (_singleton == null) {
          // keep local instance till it is fully initialized.
          // 保持本地实例直到完全初始化。
          var singleton = SpManager._();
          await singleton._init();
          _singleton = singleton;
        }
      });
    }
    return _singleton;
  }

  SpManager._();

  Future _init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static bool getBool(SpParams params, {bool defaultValue = false}) =>
      _sharedPreferences.getBool(params.toString()) ?? defaultValue;

  static int getInt(SpParams params, {int defaultValue = 0}) =>
      _sharedPreferences.getInt(params.toString()) ?? defaultValue;

  static double getDouble(SpParams params, {double defaultValue = 0.0}) =>
      _sharedPreferences.getDouble(params.toString()) ?? defaultValue;

  static String getString(SpParams params, {String defaultValue = ""}) =>
      _sharedPreferences.getString(params.toString()) ?? defaultValue;

  static List<String> getStringList(SpParams params) =>
      _sharedPreferences.getStringList(params.toString());

  static void setBool(SpParams params, bool value) =>
      _sharedPreferences.setBool(params.toString(), value);

  static void setInt(SpParams params, int value) =>
      _sharedPreferences.setInt(params.toString(), value);

  static void setDouble(SpParams params, double value) =>
      _sharedPreferences.setDouble(params.toString(), value);

  static void setString(SpParams params, String value) =>
      _sharedPreferences.setString(params.toString(), value);

  static void setStringList(SpParams params, List<String> value) =>
      _sharedPreferences.setStringList(params.toString(), value);

  static void remove(SpParams params) {
    _sharedPreferences.remove(params.toString());
  }
}
