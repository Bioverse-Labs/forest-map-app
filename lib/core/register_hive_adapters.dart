import '../models/hive/geopoint.dart';
import '../models/hive/tree.dart';
import 'package:hive/hive.dart';

void registerHiveAdapters() {
  Hive.registerAdapter(GeopointHiveAdapter());
  Hive.registerAdapter(TreeHiveAdapter());
}
