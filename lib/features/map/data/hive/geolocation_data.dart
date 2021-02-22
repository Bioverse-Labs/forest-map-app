import 'package:hive/hive.dart';

import 'geolocation_data_properties.dart';

part 'geolocation_data.g.dart';

@HiveType(typeId: 8)
class GeolocationDataHive {
  @HiveField(1)
  String name;

  @HiveField(0)
  List<GeolocationDataPropertiesHive> dataProperties;
}
