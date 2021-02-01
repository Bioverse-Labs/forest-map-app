import 'package:dartz/dartz.dart';
import 'package:forestMapApp/core/errors/exceptions.dart';
import 'package:meta/meta.dart';

import '../models/location_model.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/platform/network_info.dart';
import '../../domain/entities/location.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/location_local_data_source.dart';
import '../datasources/location_remote_data_source.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationLocalDataSourceImpl localDataSource;
  final LocationRemoteDataSourceImpl remoteDataSource;
  final NetworkInfoImpl networkInfo;

  LocationRepositoryImpl({
    @required this.localDataSource,
    @required this.remoteDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, Stream<Location>>> trackUserLocation() async {
    try {
      final stream = await localDataSource.getPositionStream();
      return Right(
        stream.expand((element) => [LocationModel.fromPosition(element)]),
      );
    } on LocationException catch (error) {
      return Left(LocationFailure(
        error.message,
        error.hasPermission,
        error.isGpsEnabled,
        stackTrace: error.stackTrace,
      ));
    }
  }

  @override
  Future<Either<Failure, Location>> saveLocation(LocationModel location) async {
    try {
      if (await networkInfo.isConnected) {
        final result = await remoteDataSource.saveLocation(location.toMap());
        return Right(result);
      } else {
        final result = await localDataSource.saveLocation(location.toMap());
        return Right(result);
      }
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
}
