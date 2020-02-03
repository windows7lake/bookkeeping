import 'package:bookkeeping/cache/db/db_provider.dart';

/// 数据库表的表名和字段建议单独写出来，方便上面根据字段查询和更新时直接使用，以及全局修改
final String kTable = "Subject";
final String kId = "id";
final String kName = "name";
final String kTags = "tags";
final String kDesc = "description";

class SubjectDao extends DBProvider {
  @override
  createTableName() => kTable;

  @override
  createTableColumn() => '''
    $kId INTEGER PRIMARY KEY, 
    $kName TEXT,
    $kTags TEXT,
    $kDesc TEXT
  ''';

  // 插入一条数据
  Future<Subject> insert(Subject subject) async {
    var db = await getDatabase();
    await db.insert(kTable, subject.toMap());
    return subject;
  }

  // 根据ID查找信息
  Future<Subject> query(int id) async {
    var db = await getDatabase();
    List<Map> maps = await db.query(
      kTable,
      columns: [kId, kName, kTags, kDesc],
      where: '$kId = ?',
      whereArgs: [id],
    );
    if (maps.length > 0) return Subject.fromMap(maps.first);
    return null;
  }

  // 根据名称查找信息
  Future<Subject> queryName(String name) async {
    var db = await getDatabase();
    List<Map> maps = await db.query(
      kTable,
      columns: [kId, kName, kTags, kDesc],
      where: '$kName = ?',
      whereArgs: [name],
    );
    if (maps.length > 0) return Subject.fromMap(maps.first);
    return null;
  }

  // 查找所有数据
  Future<List<Subject>> queryAll() async {
    var db = await getDatabase();
    List<Map> maps = await db.query(
      kTable,
      columns: [kId, kName, kTags, kDesc],
      orderBy: kId + " DESC",
    );
    if (maps == null || maps.length == 0) return null;

    List<Subject> list = [];
    for (int i = 0; i < maps.length; i++) {
      list.add(Subject.fromMap(maps[i]));
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
  Future<int> update(Subject subject) async {
    var db = await getDatabase();
    return await db.update(
      kTable,
      subject.toMap(),
      where: '$kId = ?',
      whereArgs: [subject.id],
    );
  }
}

/// 数据库表对应的model对象
class Subject {
  int id;
  String name;
  String tags;
  String description;

  Subject({this.id, this.name, this.tags, this.description});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      kId: id,
      kName: name,
      kTags: tags,
      kDesc: description,
    };
    return map;
  }

  Subject.fromMap(Map<String, dynamic> map) {
    id = map[kId];
    name = map[kName];
    tags = map[kTags];
    description = map[kDesc];
  }
}
