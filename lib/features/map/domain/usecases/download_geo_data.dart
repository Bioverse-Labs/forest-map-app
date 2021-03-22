import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:forest_map_app/core/errors/failure.dart';
import 'package:forest_map_app/core/usecases/usecase.dart';
import 'package:forest_map_app/features/map/domain/repositories/geolocation_repository.dart';
import 'package:meta/meta.dart';

import '../../../organization/domain/entities/organization.dart';

class DownloadGeoDataParams extends Equatable {
  final Organization organization;

  DownloadGeoDataParams({
    @required this.organization,
  });

  @override
  List<Object> get props => [organization];
}

class DownloadGeoData implements UseCase<void, DownloadGeoDataParams> {
  final GeolocationRepository repository;

  DownloadGeoData({
    @required this.repository,
  });

  @override
  Future<Either<Failure, void>> call(DownloadGeoDataParams params) async {
    return repository.insertDataFromFile(params.organization);
  }
}
