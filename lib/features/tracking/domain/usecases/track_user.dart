import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/location.dart';
import '../repositories/location_repository.dart';

class TrackUser
    implements UseCase<Stream<Either<Failure, Location>>, NoParams> {
  final LocationRepository locationRepository;

  TrackUser(this.locationRepository);

  @override
  Future<Either<Failure, Stream<Either<Failure, Location>>>> call(
    NoParams params,
  ) async {
    return await locationRepository.trackUserLocation();
  }
}
