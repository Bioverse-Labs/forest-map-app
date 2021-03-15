import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../organization/domain/entities/organization.dart';
import '../entities/geolocation_data_properties.dart';

abstract class GeolocationRepository {
  Future<Either<Failure, StreamController<Either<Failure, File>>>>
      getGolocationFiles(Organization organization);
  Future<Either<Failure, void>> getGeolocationData({
    Organization organization,
    List<File> files,
    StreamController<Either<Failure, List<GeolocationDataProperties>>>
        strController,
  });
}
