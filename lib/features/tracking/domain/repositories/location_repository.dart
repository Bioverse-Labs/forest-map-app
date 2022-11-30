import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../data/models/location_model.dart';
import '../entities/location.dart';

abstract class LocationRepository {
  Future<Either<Failure, Stream<Location>>> trackUserLocation();

  Future<Either<Failure, void>> saveLocation(
    String userId,
    LocationModel location,
  );

  Future<Either<Failure, Location>> getCurrentLocation();

  Future<Either<Failure, List<Location>>> getLocations(String userId);
}
