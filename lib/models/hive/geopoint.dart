import 'package:hive/hive.dart';

part 'geopoint.g.dart';

@HiveType(typeId: 2)
class GeopointHive {
  @HiveField(0)
  double lat;

  @HiveField(1)
  double lng;
}
