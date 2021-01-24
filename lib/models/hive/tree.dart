import 'package:forestMapApp/models/hive/geopoint.dart';
import 'package:hive/hive.dart';

part 'tree.g.dart';

@HiveType(typeId: 1)
class TreeHive {
  @HiveField(0)
  String name;

  @HiveField(1)
  String imagePath;

  @HiveField(2)
  GeopointHive location;
}
