import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../organization/domain/entities/organization.dart';
import '../entities/geolocation_data_properties.dart';
import '../repositories/geolocation_repository.dart';

class GetBoundaryParams extends Equatable {
  final Organization organization;

  GetBoundaryParams({@required this.organization});

  @override
  List<Object> get props => throw UnimplementedError();
}

class GetBoundary
    implements UseCase<List<GeolocationDataProperties>, GetBoundaryParams> {
  final GeolocationRepository repository;

  GetBoundary({@required this.repository});

  @override
  Future<Either<Failure, List<GeolocationDataProperties>>> call(
    GetBoundaryParams params,
  ) {
    return repository.loadBoundary(params.organization);
  }
}
