import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:forest_map_app/features/map/domain/usecases/download_geo_data.dart';
import 'package:forest_map_app/features/map/domain/usecases/get_geolocation_data.dart';
import 'package:meta/meta.dart';
import 'package:forest_map_app/core/errors/failure.dart';
import 'package:forest_map_app/features/map/domain/entities/geolocation_data_properties.dart';
import 'package:forest_map_app/features/organization/domain/entities/organization.dart';

abstract class MapNotifier {
  Future<void> downloadGeoData(Organization organization);
  Future<Either<Failure, List<GeolocationDataProperties>>> getGeoData({
    @required Organization organization,
    @required double latitude,
    @required double longitude,
  });
}

class MapNotifierImpl extends ChangeNotifier implements MapNotifier {
  final DownloadGeoData downloadGeoDataUseCase;
  final GetGeolocationData getGeolocationDataUseCase;

  bool isLoading = false;
  bool _isQuerying = false;

  MapNotifierImpl({
    @required this.downloadGeoDataUseCase,
    @required this.getGeolocationDataUseCase,
  });

  @override
  Future<void> downloadGeoData(
    Organization organization,
  ) async {
    isLoading = true;
    notifyListeners();

    final result = await downloadGeoDataUseCase(DownloadGeoDataParams(
      organization: organization,
    ));

    result.fold(
      (failure) => throw failure,
      (r) => null,
    );

    isLoading = false;
    notifyListeners();
  }

  @override
  Future<Either<Failure, List<GeolocationDataProperties>>> getGeoData({
    @required Organization organization,
    @required double latitude,
    @required double longitude,
  }) async {
    if (!_isQuerying) {
      _isQuerying = true;

      final failureOrGeoData = await getGeolocationDataUseCase(
        GetGeolocationDataParams(
          organization: organization,
          latitude: latitude,
          longitude: longitude,
        ),
      );

      _isQuerying = false;

      return failureOrGeoData.fold(
        (failure) => Left(failure),
        (geodata) => Right(geodata),
      );
    }

    return Right([]);
  }
}
