import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DirUtils {
  Future<Directory> getDocumentsDirectory() async =>
      getApplicationDocumentsDirectory();
  Future<Directory> getTempDirectory() async => getTemporaryDirectory();
  Future<String> getDbPath() async => getDatabasesPath();
  String join(List<String> paths) => p.joinAll(paths);
}
