import 'package:hive/hive.dart';

part 'location.g.dart';

@HiveType(typeId: 4)
class LocationHive {
  @HiveField(0)
  String? id;

  @HiveField(1)
  double? lat;

  @HiveField(2)
  double? lng;

  @HiveField(3)
  DateTime? timestamp;

  @HiveField(4)
  double? altitude;

  @HiveField(5)
  double? accuracy;

  @HiveField(6)
  double? heading;

  @HiveField(7)
  int? floor;

  @HiveField(8)
  double? speed;

  @HiveField(9)
  double? speedAccuracy;
}
