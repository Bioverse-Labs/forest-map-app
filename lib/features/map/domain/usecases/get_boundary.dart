import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:forest_map_app/core/errors/failure.dart';
import 'package:forest_map_app/core/usecases/usecase.dart';
import 'package:forest_map_app/features/map/domain/entities/geolocation_data_properties.dart';
import 'package:forest_map_app/features/map/domain/repositories/geolocation_repository.dart';
import 'package:forest_map_app/features/organization/domain/entities/organization.dart';
import 'package:meta/meta.dart';

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
