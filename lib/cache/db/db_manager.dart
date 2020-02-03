import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';
import 'dart:io' show Platform;

/// 数据库管理类
class DBManager {
  /// 数据库名
  static const String DB_NAME = "bookkeeping.db";

  /// 数据库版本号
  static const int DB_VERSION = 1;

  /// 数据库实例
  static Database _db;

  /// 同步锁，防止对数据库同时进行操作
  static final _lock = Lock();

  /// 初始化数据库并创建对应的表
  static init() async {
    // 获取数据库文件的存储路径
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + DB_NAME;
    if (Platform.isIOS) path = databasesPath + "/" + DB_NAME;
    // 根据数据库文件路径和数据库版本号创建数据库表
    _db = await openDatabase(
      path,
      version: DB_VERSION,
      onCreate: (Database _db, int version) async {
        // 创建表
      },
      onUpgrade: (Database _db, int oldVersion, int newVersion) async {
        // 升级数据库和表
      },
    );
  }

  /// 获取当前数据库实例
  static Future<Database> getDatabase() async {
    if (_db == null) {
      await _lock.synchronized(() async {
        if (_db == null) init();
      });
    }
    return _db;
  }

  /// 判断当前数据表是否存在
  static isTableExist(String tableName) async {
    await getDatabase();
    String sql =
        "select * from Sqlite_master where type = 'table' and name = '$tableName'";
    var result = await _db?.rawQuery(sql);
    return result != null && result.length > 0;
  }

  static Future close() async {
    _db?.close();
    _db = null;
  }
}
