import 'package:hive/hive.dart';

part 'geolocation_file.g.dart';

@HiveType(typeId: 10)
class GeolocationFileHive {
  @HiveField(1)
  String id;

  @HiveField(2)
  String fileName;

  @HiveField(3)
  DateTime downloadDate;
}
