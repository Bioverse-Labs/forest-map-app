import 'package:forest_map/core/adapters/database_adapter.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

import '../util/dir.dart';

class DatabaseAdapterImpl implements DatabaseAdapter {
  final DirUtils? dirUtils;
  final String dbName = 'forestMap.db';
  late Database db;

  DatabaseAdapterImpl({required this.dirUtils});

  @override
  Future<Database> openDatabase() async {
    final dbPath = await dirUtils!.getDbPath();
    final database = await sql.openDatabase(dirUtils!.join([dbPath, dbName]),
        version: 1, onCreate: (_db, version) async {
      await _db.execute(
        '''
          CREATE TABLE GeoData (
            id INTEGER PRIMARY KEY,
            filename TEXT,
            geohash TEXT,
            type TEXT,
            specie TEXT,
            detDate DATETIME,
            imageDate DATETIME,
            latitude DOUBLE,
            longitude DOUBLE
          )
        ''',
      );
    });

    db = database;
    return database;
  }

  @override
  Future<List<Map<String, Object?>>> runQuery({
    String? table,
    List<String>? columns,
    String? where,
    List<Object>? whereArgs,
    int? limit,
  }) async =>
      db.query(
        table!,
        columns: columns,
        where: where,
        whereArgs: whereArgs,
        limit: limit,
      );

  @override
  Future<void> insertInBatch({
    String? table,
    List<Map<String, Object?>>? fields,
  }) async {
    final batch = db.batch();

    for (var field in fields!) {
      batch.insert(table!, field);
    }

    await batch.commit(noResult: true);
  }

  @override
  Future<List<Map<String, Object?>>> runRawQuery(String query) async =>
      db.rawQuery(query);
}
