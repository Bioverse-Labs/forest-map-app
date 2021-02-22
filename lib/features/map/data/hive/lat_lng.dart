import 'package:hive/hive.dart';

part 'lat_lng.g.dart';

@HiveType(typeId: 11)
class LatLngHive {
  @HiveField(0)
  double latitude;

  @HiveField(1)
  double longitude;
}
