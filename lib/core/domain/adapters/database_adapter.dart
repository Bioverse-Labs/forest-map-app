import 'package:sqflite/sqlite_api.dart';

abstract class DatabaseAdapter {
  Future<Database> openDatabase();
  Future<List<Map<String, Object?>>> runQuery({
    String? table,
    List<String>? columns,
    String? where,
    List<Object>? whereArgs,
    int? limit,
  });
  Future<List<Map<String, Object?>>> runRawQuery(String query);
  Future<void> insertInBatch(
      {String? table, List<Map<String, Object?>>? fields});
}
