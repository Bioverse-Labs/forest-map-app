import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/location.dart';
import '../repositories/location_repository.dart';

class TrackUser implements UseCase<Stream<Location>, TrackUserParams> {
  final LocationRepository locationRepository;

  TrackUser(this.locationRepository);

  @override
  Future<Either<Failure, Stream<Location>>> call(
    TrackUserParams params,
  ) async {
    final failureOrStream = await locationRepository.trackUserLocation();
    return failureOrStream.fold(
      (failure) => Left(failure),
      (stream) {
        final _stream = stream.asBroadcastStream();
        _stream.listen((event) async {
          await locationRepository.saveLocation(params.userId, event);
        });
        return Right(_stream);
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
