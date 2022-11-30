import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:geojson/geojson.dart';

import '../../../../core/adapters/firebase_storage_adapter.dart';
import '../../../../core/adapters/http_adapter.dart';
import '../../../../core/util/dir.dart';
import '../../../../core/util/geojson.dart';
import '../../../organization/domain/entities/organization.dart';

abstract class MapRemoteDatasource {
  Future<GeoJson> downloadGeoJsonFile(String filename,
      [Organization organization]);
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

  Future<GeoJson> downloadGeoJsonFile(String filename,
      [Organization organization]) async {
    final tempDir = await dirUtils.getTempDirectory();
    final localFile = File('${tempDir.path}/$filename.geojson');

    if (!await localFile.exists()) {
      await localFile.create();
    }

    final downloadUrl = await firebaseStorageAdapter.getDownloadUrl(
      organization == null
          ? '/geolocation-data/$filename.geojson'
          : '/organizations/${organization.id}/geolocation-data/$filename.geojson',
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
