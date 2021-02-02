import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../data/models/location_model.dart';
import '../entities/location.dart';

abstract class LocationRepository {
  Future<Either<Failure, Stream<Location>>> trackUserLocation();

  Future<Either<Failure, Location>> saveLocation(
    String userId,
    LocationModel location,
  );
}
