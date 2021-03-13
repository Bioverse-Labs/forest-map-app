import 'dart:io';

import 'package:geojson/geojson.dart';

import '../../features/map/data/models/geolocation_data_model.dart';
import '../../features/map/data/models/geolocation_data_properties_model.dart';
import '../adapters/firebase_storage_adapter.dart';
import '../adapters/http_adapter.dart';
import 'geojson.dart';

Future<List<GeolocationDataModel>> parseGeoJsonToModel(
  Map<String, dynamic> params,
) async {
  final geoDataId = params['geolocationData'] as List<String>;
  final storageAdapter = params['storageAdapter'] as FirebaseStorageAdapterImpl;
  final httpAdapter = params['httpAdapter'] as HttpAdapterImpl;
  final geoJsonUtils = params['geoJsonUtils'] as GeoJsonUtils;
  final docDir = params['docDir'] as Directory;

  final result = <GeolocationDataModel>[];

  if (geoDataId == null) {
    return result;
  }

  for (var filename in geoDataId) {
    final localFile = File('${docDir.path}/$filename.geojson');
    final geoProperties = <GeolocationDataPropertiesModel>[];
    GeoJson geoJson;

    if (!await localFile.exists()) {
      await localFile.create();
      final downloadUrl = await storageAdapter.getDownloadUrl(
        '/geolocation-data/$filename.geojson',
      );
      final resp = await httpAdapter.downloadFile(downloadUrl);
      await localFile.writeAsBytes(resp.readAsBytesSync());
    }

    geoJson = await geoJsonUtils.parseFromFile(localFile);

    for (var feature in geoJson.features) {
      geoProperties.addAll(
        await geoJsonUtils.parseFeaturesToModel(feature),
      );
    }

    result.add(GeolocationDataModel(
      name: filename,
      dataProperties: geoProperties,
    ));
  }

  return result;
}
