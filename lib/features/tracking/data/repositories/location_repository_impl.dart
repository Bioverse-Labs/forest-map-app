import 'package:dartz/dartz.dart';
import '../../../../core/platform/network_info.dart';
import '../datasources/location_local_data_source.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/location.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/location_remote_data_source.dart';
import '../models/location_model.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationRemoteDataSource remoteDataSource;
  final LocationLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  LocationRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, Stream<Location>>> trackUserLocation() async {
    try {
      final stream = await localDataSource.getPositionStream();
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
  Future<Either<Failure, void>> saveLocation(
    String userId,
    LocationModel location,
  ) async {
    try {
      if (!(await networkInfo.isConnected)) {
        await localDataSource.saveLocation(userId, location);
      }

      await remoteDataSource.saveLocation(userId, location);

      return Right(null);
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
      final location = await localDataSource.getCurrentLocation();
      return Right(location);
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
  Future<Either<Failure, List<Location>>> getLocations(String userId) async {
    try {
      if (await networkInfo.isConnected) {
        final remoteLocations = await remoteDataSource.getLocations(userId);
        await localDataSource.syncLocations(userId, remoteLocations);
      }

      final locations = await localDataSource.getLocations(userId);
      return Right(locations);
    } on LocalException catch (error) {
      return Left(LocalFailure(
        error.message,
        error.code,
        error.origin,
        stackTrace: error.stackTrace,
      ));
    } on ServerException catch (error) {
      return Left(ServerFailure(
        error.message,
        error.code,
        error.origin,
        stackTrace: error.stackTrace,
      ));
    }
  }
}
