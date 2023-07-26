import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geojson/geojson.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:proximity_hash/proximity_hash.dart';

import '../../../../core/enums/exception_origin_types.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/platform/network_info.dart';
import '../../../../core/util/geojson.dart';
import '../../../organization/domain/entities/organization.dart';
import '../../domain/entities/geolocation_data_properties.dart';
import '../../domain/repositories/geolocation_repository.dart';
import '../datasources/map_local_datasource.dart';
import '../datasources/map_remote_datasource.dart';
import '../models/geolocation_data_properties_model.dart';

class GeolocationRepositoryImpl implements GeolocationRepository {
  final MapRemoteDatasource? mapRemoteDatasource;
  final MapLocalDataSource? mapLocalDataSource;
  final NetworkInfo? networkInfo;
  final Geoflutterfire? geoflutterfire;
  final GeoJsonUtils? geoJsonUtils;

  GeolocationRepositoryImpl({
    required this.mapRemoteDatasource,
    required this.mapLocalDataSource,
    required this.networkInfo,
    required this.geoflutterfire,
    required this.geoJsonUtils,
  });

  @override
  Future<Either<Failure, void>> insertDataFromFile(
    Organization? organization,
  ) async {
    if (!await networkInfo!.isConnected) {
      return Left(NoInternetFailure());
    }

    for (var filename in organization!.geolocationData!) {
      final file = await mapLocalDataSource!.getFile(filename);
      if (file == null) {
        final geoJson = await mapRemoteDatasource!.downloadGeoJsonFile(
          filename,
        );

        final geoData = await compute<Map<String, dynamic>,
            List<GeolocationDataPropertiesModel>>(
          parseDataAsPoint,
          {'geo': geoflutterfire, 'features': geoJson.features},
        );

        await mapLocalDataSource!.saveData(filename, geoData);
        await mapLocalDataSource!.saveFile(filename);
      }
    }

    return Right(null);
  }

  @override
  Future<Either<Failure, List<GeolocationDataProperties>>> getPoints({
    Organization? organization,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final geoLocation = createGeohashes(latitude, longitude, 1000, 7);

      final items = <GeolocationDataPropertiesModel>[];

      if (organization?.geolocationData == null) {
        return Right(items);
      }

      for (var filename in organization!.geolocationData!) {
        for (var location in geoLocation) {
          final records = await mapLocalDataSource!.getDataFromQuery(
            filename: filename,
            geohash: location.toUpperCase(),
          );

          items.addAll(records);
        }
      }

      return Right(items);
    } on LocalException catch (exception) {
      return Left(LocalFailure(
        exception.message,
        exception.code,
        ExceptionOriginTypes.firebaseStorage,
        stackTrace: exception.stackTrace,
      ));
    } catch (error) {
      return Left(GenericFailure([error]));
    }
  }

  @override
  Future<Either<Failure, List<GeolocationDataProperties>>> loadBoundary(
    Organization organization,
  ) async {
    try {
      GeoJson geoJson;
      if (await networkInfo!.isConnected) {
        geoJson = await mapRemoteDatasource!.downloadGeoJsonFile(
          'boundary',
          organization,
        );
        mapLocalDataSource!.saveFile('${organization.id}-boundary');
      } else {
        final file = await mapLocalDataSource!.getFile(
          '${organization.id}-boundary',
        );
        geoJson = await compute<Map<String, dynamic>, GeoJson>(
          parseGeojson,
          {
            'geoJsonUtils': geoJsonUtils,
            'file': file,
          },
        );
      }

      final geoData = await compute<Map<String, dynamic>,
          List<GeolocationDataPropertiesModel>>(
        parseDataAsPolygon,
        {'geo': geoflutterfire, 'features': geoJson.features},
      );

      return Right(geoData);
    } on FirebaseException catch (exception) {
      return Left(ServerFailure(
        exception.message,
        exception.code,
        ExceptionOriginTypes.firebaseStorage,
        stackTrace: exception.stackTrace,
      ));
    } on LocalException catch (exception) {
      return Left(LocalFailure(
        exception.message,
        exception.code,
        ExceptionOriginTypes.firebaseStorage,
        stackTrace: exception.stackTrace,
      ));
    } catch (error) {
      return Left(GenericFailure([error]));
    }
  }

  @override
  Future<Either<Failure, List<GeolocationDataProperties>>> loadVillages(
    Organization organization,
  ) async {
    try {
      GeoJson geoJson;
      if (await networkInfo!.isConnected) {
        geoJson = await mapRemoteDatasource!.downloadGeoJsonFile(
          'villages',
          organization,
        );
        mapLocalDataSource!.saveFile('${organization.id}-villages');
      } else {
        final file = await mapLocalDataSource!.getFile(
          '${organization.id}-villages',
        );
        geoJson = await compute<Map<String, dynamic>, GeoJson>(
          parseGeojson,
          {
            'geoJsonUtils': geoJsonUtils,
            'file': file,
          },
        );
      }

      final geoData = await compute<Map<String, dynamic>,
          List<GeolocationDataPropertiesModel>>(
        parseDataAsPoint,
        {'geo': geoflutterfire, 'features': geoJson.features},
      );

      return Right(geoData);
    } on FirebaseException catch (exception) {
      return Left(ServerFailure(
        exception.message,
        exception.code,
        ExceptionOriginTypes.firebaseStorage,
        stackTrace: exception.stackTrace,
      ));
    } on LocalException catch (exception) {
      return Left(LocalFailure(
        exception.message,
        exception.code,
        ExceptionOriginTypes.firebaseStorage,
        stackTrace: exception.stackTrace,
      ));
    } catch (error) {
      return Left(GenericFailure([error]));
    }
  }

  @override
  Future<Either<Failure, List<GeolocationDataProperties>>> getFirstPoint({
    Organization? organization,
  }) async {
    try {
      final items = <GeolocationDataPropertiesModel>[];

      for (var filename in organization!.geolocationData!) {
        final records = await mapLocalDataSource!.getFirstPoint(
          filename: filename,
        );

        items.addAll(records);
      }

      return Right(items);
    } catch (error) {
      return Left(
        LocalFailure(
          error.toString(),
          error.toString(),
          ExceptionOriginTypes.platform,
          stackTrace: StackTrace.fromString(
            error.toString(),
          ),
        ),
      );
    }
  }
}

Future<List<GeolocationDataPropertiesModel>> parseDataAsPoint(
  Map<String, dynamic> params,
) async {
  final geo = params['geo'] as Geoflutterfire?;
  final features = params['features'] as List<GeoJsonFeature>;

  final dataList = <GeolocationDataPropertiesModel>[];

  for (var feature in features) {
    final point = feature.geometry as GeoJsonPoint;
    final properties = feature.properties!;

    final geoLocation = geo!.point(
      latitude: point.geoPoint.latitude,
      longitude: point.geoPoint.longitude,
    );

    final data = GeolocationDataPropertiesModel.fromMap({
      ...properties,
      'geohash': geoLocation.hash,
      'latitude': point.geoPoint.latitude,
      'longitude': point.geoPoint.longitude,
    });

    dataList.add(data);
  }

  return Future.value(dataList);
}

Future<List<GeolocationDataPropertiesModel>> parseDataAsPolygon(
  Map<String, dynamic> params,
) async {
  final features = params['features'] as List<GeoJsonFeature>;

  final dataList = <GeolocationDataPropertiesModel>[];

  for (var feature in features) {
    final multipoly = feature.geometry as GeoJsonMultiPolygon;
    final properties = feature.properties;

    for (var polygon in multipoly.polygons) {
      final points = <LatLng>[];

      for (var geoSerie in polygon.geoSeries) {
        for (var point in geoSerie.geoPoints) {
          points.add(LatLng(point.latitude, point.longitude));
        }
      }

      final data = GeolocationDataPropertiesModel.fromMap({
        ...properties!,
        'points': points,
      });

      dataList.add(data);
    }
  }

  return Future.value(dataList);
}

Future<GeoJson> parseGeojson(Map<String, dynamic> params) async {
  final geoJsonUtils = params['geoJsonUtils'] as GeoJsonUtils;
  final file = params['file'] as File;

  final geojson = await geoJsonUtils.parseFromFile(file);

  return geojson;
}
