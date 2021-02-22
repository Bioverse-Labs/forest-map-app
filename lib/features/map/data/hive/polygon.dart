import 'package:forestMapApp/features/map/data/hive/lat_lng.dart';
import 'package:hive/hive.dart';

part 'polygon.g.dart';

@HiveType(typeId: 10)
class PolygonHive {
  @HiveField(0)
  String id;

  @HiveField(1)
  List<LatLngHive> points;
}
