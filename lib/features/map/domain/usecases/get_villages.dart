import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../organization/domain/entities/organization.dart';
import '../entities/geolocation_data_properties.dart';
import '../repositories/geolocation_repository.dart';

class GetVillagesParams extends Equatable {
  final Organization organization;

  GetVillagesParams({@required this.organization});

  @override
  List<Object> get props => throw UnimplementedError();
}

class GetVillages
    implements UseCase<List<GeolocationDataProperties>, GetVillagesParams> {
  final GeolocationRepository repository;

  GetVillages({@required this.repository});

  @override
  Future<Either<Failure, List<GeolocationDataProperties>>> call(
    GetVillagesParams params,
  ) {
    return repository.loadVillages(params.organization);
  }
}
