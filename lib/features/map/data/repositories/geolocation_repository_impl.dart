import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:forest_map_app/core/util/uuid_generator.dart';
import 'package:geojson/geojson.dart';
import 'package:meta/meta.dart';

import '../../../../core/adapters/firebase_storage_adapter.dart';
import '../../../../core/adapters/http_adapter.dart';
import '../../../../core/enums/exception_origin_types.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/util/dir.dart';
import '../../../../core/util/geojson.dart';
import '../../../../core/util/localized_string.dart';
import '../../../organization/domain/entities/organization.dart';
import '../../domain/entities/geolocation_data_properties.dart';
import '../../domain/repositories/geolocation_repository.dart';
import '../models/geolocation_data_properties_model.dart';

class GeolocationRepositoryImpl implements GeolocationRepository {
  final FirebaseStorageAdapterImpl firebaseStorageAdapter;
  final HttpAdapter httpAdapter;
  final GeoJsonUtils geoJsonUtils;
  final DirUtils dirUtils;
  final LocalizedString localizedString;
  final UUIDGenerator uuidGenerator;

  GeolocationRepositoryImpl({
    @required this.firebaseStorageAdapter,
    @required this.httpAdapter,
    @required this.geoJsonUtils,
    @required this.dirUtils,
    @required this.localizedString,
    @required this.uuidGenerator,
  });

  @override
  Future<Either<Failure, void>> getGeolocationData({
    Organization organization,
    List<File> files,
    StreamController<Either<Failure, List<GeolocationDataProperties>>>
        strController,
  }) async {
    if (files.length > 0) {
      try {
        for (var file in files) {
          final geoJson = await compute<Map<String, dynamic>, GeoJson>(
            parseGeojson,
            {'geoJsonUtils': geoJsonUtils, 'file': file},
          );

          try {
            final data = await compute<Map<String, dynamic>,
                List<GeolocationDataProperties>>(
              parseData,
              {
                'features': geoJson.features,
                'uuidGenerator': uuidGenerator,
              },
            );

            strController.sink.add(Right(data));
          } catch (error) {
            strController.sink.add(Left(LocalFailure(
              error.toString(),
              error.toString(),
              ExceptionOriginTypes.platform,
              stackTrace: StackTrace.fromString(error.toString()),
            )));
          }
        }
      } catch (error) {
        return Left(LocalFailure(
          error.toString(),
          error.toString(),
          ExceptionOriginTypes.platform,
          stackTrace: StackTrace.fromString(error.toString()),
        ));
      }
    }

    return Right(null);
  }

  @override
  Future<Either<Failure, StreamController<Either<Failure, File>>>>
      getGolocationFiles(
    Organization organization,
  ) async {
    if (organization.geolocationData.length > 0) {
      final docDir = await dirUtils.getDocumentsDirectory();
      // ignore: close_sinks
      final strController = StreamController<Either<Failure, File>>();

      organization.geolocationData.forEach((filename) async {
        try {
          final localFile = File('${docDir.path}/$filename.geojson');

          if (!await localFile.exists()) {
            await localFile.create();
            final downloadUrl = await firebaseStorageAdapter.getDownloadUrl(
              '/geolocation-data/$filename.geojson',
            );
            final resp = await httpAdapter.downloadFile(downloadUrl);
            await localFile.writeAsBytes(resp.readAsBytesSync());
          }

          strController.sink.add(Right(localFile));
        } on FirebaseException catch (error) {
          strController.sink.add(Left(ServerFailure(
            error.message,
            error.code,
            ExceptionOriginTypes.firebaseStorage,
            stackTrace: error.stackTrace,
          )));
        } catch (error) {
          strController.sink.add(Left(LocalFailure(
            error?.message,
            error?.code,
            ExceptionOriginTypes.unkown,
            stackTrace: StackTrace.fromString(error.toString()),
          )));
        }
      });

      return Right(strController);
    }

    return null;
  }
}

Future<GeoJson> parseGeojson(Map<String, dynamic> params) async {
  final geoJsonUtils = params['geoJsonUtils'] as GeoJsonUtils;
  final file = params['file'] as File;

  final geojson = await geoJsonUtils.parseFromFile(file);

  return geojson;
}

Future<List<GeolocationDataProperties>> parseData(
  Map<String, dynamic> params,
) async {
  final uuidGenerator = params['uuidGenerator'] as UUIDGenerator;
  final features = params['features'] as List<GeoJsonFeature>;

  final dataList = <GeolocationDataProperties>[];

  for (var feature in features) {
    final point = feature.geometry as GeoJsonPoint;
    final properties = feature.properties;

    final data = GeolocationDataPropertiesModel.fromMap({
      'id': uuidGenerator.generateUID(),
      ...properties,
      'latitude': point.geoPoint.latitude,
      'longitude': point.geoPoint.longitude,
    });

    dataList.add(data);
  }

  return Future.value(dataList);
}
