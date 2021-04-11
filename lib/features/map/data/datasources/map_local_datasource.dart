import 'package:meta/meta.dart';

import '../../../../core/adapters/database_adapter.dart';
import '../../../../core/adapters/hive_adapter.dart';
import '../hive/geolocation_file.dart';
import '../models/geolocation_data_properties_model.dart';

abstract class MapLocalDataSource {
  Future<List<GeolocationDataPropertiesModel>> getDataFromQuery({
    String filename,
    String geohash,
  });
  Future<List<GeolocationDataPropertiesModel>> getFirstPoint({
    String filename,
  });
  Future<GeolocationFileHive> getFile(String filename);
  Future<void> saveData(
      String filename, List<GeolocationDataPropertiesModel> geodata);
  Future<void> saveFile(String filename);
}

class MapLocalDataSourceImpl implements MapLocalDataSource {
  final DatabaseAdapter databaseAdapter;
  final HiveAdapter<GeolocationFileHive> hiveAdapter;

  MapLocalDataSourceImpl({
    @required this.databaseAdapter,
    @required this.hiveAdapter,
  });

  @override
  Future<List<GeolocationDataPropertiesModel>> getDataFromQuery({
    String filename,
    String geohash,
  }) async {
    final result = await databaseAdapter.runRawQuery(
      '''
        SELECT * FROM GeoData
        WHERE geohash LIKE "%${geohash.toUpperCase()}%"
        AND filename = "${filename.toUpperCase()}"
        LIMIT 100
      ''',
    );

    return result
        ?.map<GeolocationDataPropertiesModel>(
          (e) => GeolocationDataPropertiesModel.fromMap(e),
        )
        ?.toList();
  }

  @override
  Future<GeolocationFileHive> getFile(String filename) async {
    return hiveAdapter.get(filename);
  }

  @override
  Future<void> saveFile(String filename) async {
    final hiveObject = GeolocationFileHive()
      ..id = filename
      ..fileName = filename
      ..downloadDate = DateTime.now();

    await hiveAdapter.put(filename, hiveObject);
  }

  @override
  Future<void> saveData(
    String filename,
    List<GeolocationDataPropertiesModel> geodata,
  ) async {
    final data = geodata
        .map((e) => {
              'geohash': e.geohash.toUpperCase(),
              'type': e.type ?? '',
              'specie': e.specie ?? '',
              'detDate': e.detDate,
              'imageDate': e.imageDate,
              'latitude': e.latitude,
              'longitude': e.longitude,
              'filename': filename.toUpperCase(),
            })
        .toList();

    await databaseAdapter.insertInBatch(table: 'GeoData', fields: data);
  }

  @override
  Future<List<GeolocationDataPropertiesModel>> getFirstPoint({
    String filename,
  }) async {
    final result = await databaseAdapter.runRawQuery(
      '''
        SELECT * FROM GeoData
        WHERE filename = "${filename.toUpperCase()}"
        LIMIT 1
      ''',
    );

    return result
        ?.map<GeolocationDataPropertiesModel>(
          (e) => GeolocationDataPropertiesModel.fromMap(e),
        )
        ?.toList();
  }
}
