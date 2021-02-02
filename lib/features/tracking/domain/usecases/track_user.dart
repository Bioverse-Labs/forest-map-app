import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/location_repository.dart';

class TrackUser implements UseCase<void, TrackUserParams> {
  final LocationRepository locationRepository;

  TrackUser(this.locationRepository);

  @override
  Future<Either<Failure, void>> call(
    TrackUserParams params,
  ) async {
    return await locationRepository.trackUserLocation();
  }
}

class TrackUserParams extends Equatable {
  final String userId;

  TrackUserParams(this.userId);

  @override
  List<Object> get props => [userId];
}
