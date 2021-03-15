import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../organization/domain/entities/organization.dart';
import '../entities/geolocation_data_properties.dart';
import '../repositories/geolocation_repository.dart';

class GetGeolocationDataParams extends Equatable {
  final Organization organization;
  final List<File> files;
  final StreamController<Either<Failure, List<GeolocationDataProperties>>>
      strController;

  GetGeolocationDataParams({
    @required this.organization,
    @required this.files,
    @required this.strController,
  });

  @override
  List<Object> get props => [organization, files, strController];
}

class GetGeolocationData implements UseCase<void, GetGeolocationDataParams> {
  final GeolocationRepository repository;

  GetGeolocationData({@required this.repository});

  @override
  Future<Either<Failure, void>> call(GetGeolocationDataParams params) {
    return repository.getGeolocationData(
      organization: params.organization,
      files: params.files,
      strController: params.strController,
    );
  }
}
