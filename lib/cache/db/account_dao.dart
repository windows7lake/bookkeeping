import 'package:bookkeeping/cache/db/db_provider.dart';

/// 数据库表的表名和字段建议单独写出来，方便上面根据字段查询和更新时直接使用，以及全局修改
final String kTable = "Account";
final String kId = "id";
final String kName = "name";
final String kType = "type";
final String kDesc = "description";

class AccountDao extends DBProvider {
  @override
  createTableName() => kTable;

  @override
  createTableColumn() => '''
    $kId INTEGER PRIMARY KEY, 
    $kName TEXT,
    $kType TEXT,
    $kDesc TEXT
  ''';

  // 插入一条数据
  Future<Account> insert(Account account) async {
    var db = await getDatabase();
    await db.insert(kTable, account.toMap());
    return account;
  }

  // 根据ID查找信息
  Future<Account> query(int id) async {
    var db = await getDatabase();
    List<Map> maps = await db.query(
      kTable,
      columns: [kId, kName, kType, kDesc],
      where: '$kId = ?',
      whereArgs: [id],
    );
    if (maps.length > 0) return Account.fromMap(maps.first);
    return null;
  }

  // 根据名称查找信息
  Future<Account> queryName(String name) async {
    var db = await getDatabase();
    List<Map> maps = await db.query(
      kTable,
      columns: [kId, kName, kType, kDesc],
      where: '$kName = ?',
      whereArgs: [name],
    );
    if (maps.length > 0) return Account.fromMap(maps.first);
    return null;
  }

  // 查找所有数据
  Future<List<Account>> queryAll() async {
    var db = await getDatabase();
    List<Map> maps = await db.query(
      kTable,
      columns: [kId, kName, kType, kDesc],
      orderBy: kId + " DESC",
    );
    if (maps == null || maps.length == 0) return null;

    List<Account> list = [];
    for (int i = 0; i < maps.length; i++) {
      list.add(Account.fromMap(maps[i]));
    }
    return list;
  }

  // 根据ID删除信息
  Future<int> delete(int id) async {
    var db = await getDatabase();
    return await db.delete(
      kTable,
      where: '$kId = ?',
      whereArgs: [id],
    );
  }

  // 删除所有信息
  Future<int> deleteAll() async {
    var db = await getDatabase();
    return await db.rawDelete("DELETE FROM $kTable");
  }

  // 更新信息
  Future<int> update(Account account) async {
    var db = await getDatabase();
    return await db.update(
      kTable,
      account.toMap(),
      where: '$kId = ?',
      whereArgs: [account.id],
    );
  }
}

/// 数据库表对应的model对象
class Account {
  int id;
  String name;
  String type;
  String description;

  Account({this.id, this.name, this.type, this.description});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      kId: id,
      kName: name,
      kType: type,
      kDesc: description,
    };
    return map;
  }

  Account.fromMap(Map<String, dynamic> map) {
    id = map[kId];
    name = map[kName];
    type = map[kType];
    description = map[kDesc];
  }
}
