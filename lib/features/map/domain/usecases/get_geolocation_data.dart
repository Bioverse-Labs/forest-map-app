import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../organization/domain/entities/organization.dart';
import '../repositories/geolocation_repository.dart';

class GetGeolocationDataParams extends Equatable {
  final Organization organization;

  GetGeolocationDataParams({@required this.organization});

  @override
  List<Object> get props => [organization];
}

class GetGeolocationData
    implements UseCase<Organization, GetGeolocationDataParams> {
  final GeolocationRepository repository;

  GetGeolocationData({@required this.repository});

  @override
  Future<Either<Failure, Organization>> call(GetGeolocationDataParams params) {
    return repository.getGeolocationData(params.organization);
  }
}
