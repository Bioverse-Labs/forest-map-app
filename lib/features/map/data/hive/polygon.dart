import 'package:hive/hive.dart';

import 'lat_lng.dart';

part 'polygon.g.dart';

@HiveType(typeId: 10)
class PolygonHive {
  @HiveField(0)
  String id;

  @HiveField(1)
  List<LatLngHive> points;
}
