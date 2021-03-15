import 'package:hive/hive.dart';

part 'geolocation_data_properties.g.dart';

@HiveType(typeId: 9)
class GeolocationDataPropertiesHive {
  @HiveField(0)
  String id;

  @HiveField(1)
  String type;

  @HiveField(2)
  String specie;

  @HiveField(3)
  DateTime detDate;

  @HiveField(4)
  DateTime imageDate;

  @HiveField(5)
  double latitude;

  @HiveField(6)
  double longitude;
}
