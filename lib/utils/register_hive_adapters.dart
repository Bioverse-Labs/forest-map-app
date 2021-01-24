import 'package:forestMapApp/models/hive/geopoint.dart';
import 'package:forestMapApp/models/hive/tree.dart';
import 'package:hive/hive.dart';

void registerHiveAdapters() {
  Hive.registerAdapter(GeopointHiveAdapter());
  Hive.registerAdapter(TreeHiveAdapter());
}
