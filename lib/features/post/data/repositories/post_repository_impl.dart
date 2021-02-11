import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/platform/location.dart';
import '../../../../core/platform/network_info.dart';
import '../../../organization/domain/entities/organization.dart';
import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/post_local_data_source.dart';
import '../datasources/post_remote_data_source.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;
  final PostLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  final LocationUtils locationUtils;

  PostRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
    @required this.locationUtils,
  });

  @override
  Future<Either<Failure, void>> savePost({
    @required String organizationId,
    @required String userId,
    @required Organization organization,
    @required File file,
    @required String specie,
  }) async {
    try {
      final hasPermission = await locationUtils.checkLocationPermission();
      final location = await locationUtils.getCurrentPosition(hasPermission);

      if (!await networkInfo.isConnected) {
        return Right(await localDataSource.savePost(
          userId: userId,
          organizationId: organizationId,
          file: file,
          location: location,
        ));
      }

      return Right(await remoteDataSource.savePost(
        userId: userId,
        organizationId: organizationId,
        file: file,
        location: location,
      ));
    } on LocationException catch (exception) {
      return Left(LocationFailure(
        exception.message,
        exception.hasPermission,
        exception.isGpsEnabled,
        stackTrace: exception.stackTrace,
      ));
    } on LocalException catch (exception) {
      return Left(LocalFailure(
        exception.message,
        exception.code,
        exception.origin,
        stackTrace: exception.stackTrace,
      ));
    } on ServerException catch (exception) {
      return Left(ServerFailure(
        exception.message,
        exception.code,
        exception.origin,
        stackTrace: exception.stackTrace,
      ));
    }
  }

  @override
  Future<Either<Failure, StreamController<Either<Failure, Post>>>>
      uploadCachedPost() async {
    try {
      final posts = await localDataSource.getAllPosts();
      // ignore: close_sinks
      final streamController = StreamController<Either<Failure, Post>>();

      for (var post in posts) {
        if (!await networkInfo.isConnected) {
          streamController.sink.addError(Left(NoInternetFailure()));
          break;
        }

        await remoteDataSource.savePost(
          userId: post.userId,
          organizationId: post.organizationId,
          file: File(post.imageUrl),
          location: post.location,
          specie: post.specie,
          timestamp: post.timestamp,
        );

        streamController.sink.add(Right(post));
      }

      return Right(streamController);
    } on LocationException catch (exception) {
      return Left(LocationFailure(
        exception.message,
        exception.hasPermission,
        exception.isGpsEnabled,
        stackTrace: exception.stackTrace,
      ));
    } on LocalException catch (exception) {
      return Left(LocalFailure(
        exception.message,
        exception.code,
        exception.origin,
        stackTrace: exception.stackTrace,
      ));
    } on ServerException catch (exception) {
      return Left(ServerFailure(
        exception.message,
        exception.code,
        exception.origin,
        stackTrace: exception.stackTrace,
      ));
    }
  }
}
