import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/location.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/location_data_source.dart';
import '../models/location_model.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationDataSourceImpl dataSource;

  LocationRepositoryImpl({@required this.dataSource});

  @override
  Future<Either<Failure, Stream<Location>>> trackUserLocation() async {
    try {
      final stream = await dataSource.getPositionStream();
      return Right(stream);
    } on LocationException catch (error) {
      return Left(LocationFailure(
        error.message,
        error.hasPermission,
        error.isGpsEnabled,
        stackTrace: error.stackTrace,
      ));
    } on LocalException catch (error) {
      return Left(LocalFailure(
        error.message,
        error.code,
        error.origin,
        stackTrace: error.stackTrace,
      ));
    }
  }

  @override
  Future<Either<Failure, Location>> saveLocation(
    String userId,
    LocationModel location,
  ) async {
    try {
      final result = await dataSource.saveLocation(userId, location.toMap());
      return Right(result);
    } on ServerException catch (exception) {
      return Left(ServerFailure(
        exception.message,
        exception.code,
        exception.origin,
        stackTrace: exception.stackTrace,
      ));
    } on LocalException catch (error) {
      return Left(LocalFailure(
        error.message,
        error.code,
        error.origin,
        stackTrace: error.stackTrace,
      ));
    }
  }

  @override
  Future<Either<Failure, Location>> getCurrentLocation() async {
    try {
      return Right(await dataSource.getCurrentLocation());
    } on LocationException catch (error) {
      return Left(LocationFailure(
        error.message,
        error.hasPermission,
        error.isGpsEnabled,
        stackTrace: error.stackTrace,
      ));
    } on LocalException catch (error) {
      return Left(LocalFailure(
        error.message,
        error.code,
        error.origin,
        stackTrace: error.stackTrace,
      ));
    }
  }
}
