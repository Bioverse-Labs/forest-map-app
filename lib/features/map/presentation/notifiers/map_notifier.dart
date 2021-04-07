import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failure.dart';
import '../../../organization/domain/entities/organization.dart';
import '../../domain/entities/geolocation_data_properties.dart';
import '../../domain/usecases/download_geo_data.dart';
import '../../domain/usecases/get_boundary.dart';
import '../../domain/usecases/get_geolocation_data.dart';
import '../../domain/usecases/get_villages.dart';

abstract class MapNotifier {
  Future<void> downloadGeoData(Organization organization);
  Future<Either<Failure, List<GeolocationDataProperties>>> getGeoData({
    @required Organization organization,
    @required double latitude,
    @required double longitude,
  });
  Future<void> getBoundary(Organization organization);
  Future<void> getVillages(Organization organization);
}

class MapNotifierImpl extends ChangeNotifier implements MapNotifier {
  final DownloadGeoData downloadGeoDataUseCase;
  final GetGeolocationData getGeolocationDataUseCase;
  final GetBoundary getBoundaryUseCase;
  final GetVillages getVillagesUseCase;

  bool isLoading = false;
  bool isQuerying = false;
  List<GeolocationDataProperties> boundary = [];
  List<GeolocationDataProperties> villages = [];

  MapNotifierImpl({
    @required this.downloadGeoDataUseCase,
    @required this.getGeolocationDataUseCase,
    @required this.getBoundaryUseCase,
    @required this.getVillagesUseCase,
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

  @override
  Future<void> getBoundary(Organization organization) async {
    isLoading = true;
    notifyListeners();

    final failureOrBoundary = await getBoundaryUseCase(GetBoundaryParams(
      organization: organization,
    ));

    isLoading = false;
    notifyListeners();

    failureOrBoundary.fold(
      (failure) => throw failure,
      (data) {
        boundary = data;
        notifyListeners();
      },
    );
  }

  @override
  Future<void> getVillages(Organization organization) async {
    isLoading = true;
    notifyListeners();

    final failureOrBoundary = await getVillagesUseCase(GetVillagesParams(
      organization: organization,
    ));

    isLoading = false;
    notifyListeners();

    failureOrBoundary.fold(
      (failure) => throw failure,
      (data) {
        villages = data;
        notifyListeners();
      },
    );
  }
}
