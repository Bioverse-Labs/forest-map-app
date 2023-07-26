import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../organization/domain/entities/organization.dart';
import '../repositories/geolocation_repository.dart';

class DownloadGeoDataParams extends Equatable {
  final Organization organization;

  DownloadGeoDataParams({
    required this.organization,
  });

  @override
  List<Object> get props => [organization];
}

class DownloadGeoData implements UseCase<void, DownloadGeoDataParams> {
  final GeolocationRepository? repository;

  DownloadGeoData({
    required this.repository,
  });

  @override
  Future<Either<Failure, void>> call(DownloadGeoDataParams params) async {
    return repository!.insertDataFromFile(params.organization);
  }
}
