import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../organization/data/models/organization_model.dart';
import '../../../organization/domain/entities/organization.dart';

abstract class GeolocationRepository {
  Future<Either<Failure, StreamController<Either<Failure, File>>>>
      getGolocationFiles(Organization organization);
  Future<Either<Failure, OrganizationModel>> getGeolocationData(
    Organization organization,
  );
}
