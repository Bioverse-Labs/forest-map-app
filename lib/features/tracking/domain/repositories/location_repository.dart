import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/location.dart';

abstract class LocationRepository {
  Future<Either<Failure, Stream<Either<Failure, Location>>>>
      trackUserLocation();
}
