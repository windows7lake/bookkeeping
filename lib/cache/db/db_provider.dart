import 'package:bookkeeping/cache/db/db_manager.dart';
import 'package:bookkeeping/util/string_ext.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

/// 数据表管理基类
abstract class DBProvider {
  bool isTableExist = false;

  /// 要创建的表名
  createTableName();

  /// 要创建的字段
  createTableColumn();

  /// 获取当前数据库实例
  Future<Database> getDatabase() async {
    return await open();
  }

  /// 创建表并返回数据库实例
  @mustCallSuper
  open() async {
    if (!isTableExist) await prepare();
    return await DBManager.getDatabase();
  }

  /// 数据表的创建
  @mustCallSuper
  prepare() async {
    isTableExist = await DBManager.isTableExist(createTableName());
    if (!isTableExist) {
      Database db = await DBManager.getDatabase();
      if (StringExt.isNullOrEmpty(createTableName()))
        throw Exception("数据表表名不能为空");
      if (StringExt.isNullOrEmpty(createTableColumn()))
        throw Exception("数据表字段不能为空");
      return await db?.execute('''
        create table ${createTableName()} (
          ${createTableColumn()}
        )
        ''');
    }
  }
}
