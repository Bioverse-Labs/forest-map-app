import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../organization/domain/entities/organization.dart';
import '../entities/geolocation_data_properties.dart';
import '../repositories/geolocation_repository.dart';

class GetGeolocationDataParams extends Equatable {
  final Organization? organization;
  final double latitude;
  final double longitude;

  GetGeolocationDataParams({
    this.organization,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [organization, latitude, longitude];
}

class GetGeolocationData
    implements
        UseCase<List<GeolocationDataProperties>, GetGeolocationDataParams> {
  final GeolocationRepository? repository;

  GetGeolocationData({required this.repository});

  @override
  Future<Either<Failure, List<GeolocationDataProperties>>> call(
    GetGeolocationDataParams params,
  ) {
    return repository!.getPoints(
      organization: params.organization,
      latitude: params.latitude,
      longitude: params.longitude,
    );
  }
}
