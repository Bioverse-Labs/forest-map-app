import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../organization/domain/entities/organization.dart';
import '../entities/geolocation_data_properties.dart';
import '../repositories/geolocation_repository.dart';

class GetFirstPointParams extends Equatable {
  final Organization organization;

  GetFirstPointParams({
    required this.organization,
  });

  @override
  List<Object> get props => [organization];
}

class GetFirstPoint
    implements UseCase<List<GeolocationDataProperties>, GetFirstPointParams> {
  final GeolocationRepository? repository;

  GetFirstPoint({required this.repository});

  @override
  Future<Either<Failure, List<GeolocationDataProperties>>> call(
    GetFirstPointParams params,
  ) {
    return repository!.getFirstPoint(organization: params.organization);
  }
}
