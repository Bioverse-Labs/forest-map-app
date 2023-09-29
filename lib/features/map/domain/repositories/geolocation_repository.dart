import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../organization/domain/entities/organization.dart';
import '../entities/geolocation_data_properties.dart';

abstract class GeolocationRepository {
  Future<Either<Failure, void>> insertDataFromFile(
    Organization organization,
  );
  Future<Either<Failure, List<GeolocationDataProperties>>> getPoints({
    Organization? organization,
    required double latitude,
    required double longitude,
  });
  Future<Either<Failure, List<GeolocationDataProperties>>> loadBoundary(
    Organization organization,
  );
  Future<Either<Failure, List<GeolocationDataProperties>>> loadVillages(
    Organization organization,
  );
  Future<Either<Failure, List<GeolocationDataProperties>>> getFirstPoint({
    Organization? organization,
  });
}
