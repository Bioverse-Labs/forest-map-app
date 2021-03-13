import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:forest_map_app/core/errors/failure.dart';
import 'package:forest_map_app/core/usecases/usecase.dart';
import 'package:forest_map_app/features/map/domain/repositories/geolocation_repository.dart';
import 'package:meta/meta.dart';

import '../../../organization/domain/entities/organization.dart';

class GetGeolocationFilesParams extends Equatable {
  final Organization organization;

  GetGeolocationFilesParams({@required this.organization});

  @override
  List<Object> get props => [organization];
}

class GetGeolocationFiles
    implements
        UseCase<StreamController<Either<Failure, File>>,
            GetGeolocationFilesParams> {
  final GeolocationRepository repository;

  GetGeolocationFiles({@required this.repository});

  @override
  Future<Either<Failure, StreamController<Either<Failure, File>>>> call(
    GetGeolocationFilesParams params,
  ) {
    return repository.getGolocationFiles(params.organization);
  }
}
