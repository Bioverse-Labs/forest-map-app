import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geojson/geojson.dart';
import 'package:meta/meta.dart';
import 'package:proximity_hash/proximity_hash.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/platform/network_info.dart';
import '../../../organization/domain/entities/organization.dart';
import '../../domain/entities/geolocation_data_properties.dart';
import '../../domain/repositories/geolocation_repository.dart';
import '../datasources/map_local_datasource.dart';
import '../datasources/map_remote_datasource.dart';
import '../models/geolocation_data_properties_model.dart';

class GeolocationRepositoryImpl implements GeolocationRepository {
  final MapRemoteDatasource mapRemoteDatasource;
  final MapLocalDataSource mapLocalDataSource;
  final NetworkInfo networkInfo;
  final Geoflutterfire geoflutterfire;

  GeolocationRepositoryImpl({
    @required this.mapRemoteDatasource,
    @required this.mapLocalDataSource,
    @required this.networkInfo,
    @required this.geoflutterfire,
  });

  @override
  Future<Either<Failure, void>> insertDataFromFile(
    Organization organization,
  ) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure());
    }

    for (var filename in organization.geolocationData) {
      final file = await mapLocalDataSource.getFile(filename);
      if (file == null) {
        final geoJson = await mapRemoteDatasource.downloadGeoJsonFile(
          filename,
        );

        final geoData = await compute<Map<String, dynamic>,
            List<GeolocationDataPropertiesModel>>(
          parseData,
          {
            'geo': geoflutterfire,
            'features': geoJson.features,
          },
        );

        await mapLocalDataSource.saveData(filename, geoData);
        await mapLocalDataSource.saveFile(filename);
      }
    }

    return Right(null);
  }

  @override
  Future<Either<Failure, List<GeolocationDataProperties>>> getPoints({
    Organization organization,
    double latitude,
    double longitude,
  }) async {
    final geoLocation = createGeohashes(latitude, longitude, 1000, 7);

    final items = <GeolocationDataPropertiesModel>[];

    for (var filename in organization.geolocationData) {
      for (var location in geoLocation) {
        final records = await mapLocalDataSource.getDataFromQuery(
          filename: filename,
          geohash: location.toUpperCase(),
        );

        items.addAll(records);
      }
    }

    return Right(items);
  }
}

Future<List<GeolocationDataPropertiesModel>> parseData(
  Map<String, dynamic> params,
) async {
  final geo = params['geo'] as Geoflutterfire;
  final features = params['features'] as List<GeoJsonFeature>;

  final dataList = <GeolocationDataPropertiesModel>[];

  for (var feature in features) {
    final point = feature.geometry as GeoJsonPoint;
    final properties = feature.properties;

    final geoLocation = geo.point(
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
