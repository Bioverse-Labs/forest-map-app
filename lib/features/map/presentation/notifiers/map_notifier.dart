import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failure.dart';
import '../../../organization/domain/entities/organization.dart';
import '../../domain/entities/geolocation_data_properties.dart';
import '../../domain/usecases/download_geo_data.dart';
import '../../domain/usecases/get_geolocation_data.dart';

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
  bool isQuerying = false;

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
    if (!isQuerying) {
      isQuerying = true;
      notifyListeners();

      final failureOrGeoData = await getGeolocationDataUseCase(
        GetGeolocationDataParams(
          organization: organization,
          latitude: latitude,
          longitude: longitude,
        ),
      );

      isQuerying = false;
      notifyListeners();

      return failureOrGeoData.fold(
        (failure) => Left(failure),
        (geodata) => Right(geodata),
      );
    }

    return Right([]);
  }
}
