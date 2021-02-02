import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../entities/location.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/location_repository.dart';

class TrackUser
    implements UseCase<StreamSubscription<Location>, TrackUserParams> {
  final LocationRepository locationRepository;

  TrackUser(this.locationRepository);

  @override
  Future<Either<Failure, StreamSubscription<Location>>> call(
    TrackUserParams params,
  ) async {
    final failureOrStream = await locationRepository.trackUserLocation();
    return failureOrStream.fold(
      (failure) => Left(failure),
      (stream) {
        return Right(stream.listen((event) async {
          await locationRepository.saveLocation(params.userId, event);
        }));
      },
    );
  }
}

class TrackUserParams extends Equatable {
  final String userId;

  TrackUserParams(this.userId);

  @override
  List<Object> get props => [userId];
}
