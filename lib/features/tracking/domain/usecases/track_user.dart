import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/location.dart';
import '../repositories/location_repository.dart';

class TrackUser implements UseCase<Stream<Location>, NoParams> {
  final LocationRepository locationRepository;

  TrackUser(this.locationRepository);

  @override
  Future<Either<Failure, Stream<Location>>> call(
    NoParams params,
  ) async {
    return locationRepository.trackUserLocation();
  }
}
