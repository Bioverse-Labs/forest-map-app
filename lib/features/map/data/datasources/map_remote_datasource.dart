import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:forest_map_app/core/adapters/firebase_storage_adapter.dart';
import 'package:forest_map_app/core/adapters/http_adapter.dart';
import 'package:forest_map_app/core/util/dir.dart';
import 'package:forest_map_app/core/util/geojson.dart';
import 'package:geojson/geojson.dart';
import 'package:meta/meta.dart';

abstract class MapRemoteDatasource {
  Future<GeoJson> downloadGeoJsonFile(String filename);
}

class MapRemoteDatasourceImpl implements MapRemoteDatasource {
  final HttpAdapter httpAdapter;
  final FirebaseStorageAdapterImpl firebaseStorageAdapter;
  final DirUtils dirUtils;
  final GeoJsonUtils geoJsonUtils;

  MapRemoteDatasourceImpl({
    @required this.httpAdapter,
    @required this.firebaseStorageAdapter,
    @required this.dirUtils,
    @required this.geoJsonUtils,
  });

  Future<GeoJson> downloadGeoJsonFile(String filename) async {
    final tempDir = await dirUtils.getTempDirectory();
    final localFile = File('${tempDir.path}/$filename.geojson');

    await localFile.create();
    final downloadUrl = await firebaseStorageAdapter.getDownloadUrl(
      '/geolocation-data/$filename.geojson',
    );
    final resp = await httpAdapter.downloadFile(downloadUrl);
    await localFile.writeAsBytes(resp.readAsBytesSync());

    final geojson = await compute<Map<String, dynamic>, GeoJson>(
      parseGeojson,
      {
        'geoJsonUtils': geoJsonUtils,
        'file': localFile,
      },
    );

    return geojson;
  }
}

Future<GeoJson> parseGeojson(Map<String, dynamic> params) async {
  final geoJsonUtils = params['geoJsonUtils'] as GeoJsonUtils;
  final file = params['file'] as File;

  final geojson = await geoJsonUtils.parseFromFile(file);

  return geojson;
}
