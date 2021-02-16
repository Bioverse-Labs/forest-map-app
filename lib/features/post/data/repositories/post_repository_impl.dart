import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/platform/location.dart';
import '../../../../core/platform/network_info.dart';
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
          specie: specie,
        ));
      }

      return Right(await remoteDataSource.savePost(
        userId: userId,
        organizationId: organizationId,
        file: file,
        location: location,
        specie: specie,
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
        _uploadInIsolate(post).then(
          (failureOrBool) => failureOrBool.fold(
            (failure) {
              if (!streamController.isClosed) {
                streamController?.sink?.add(Left(failure));
              }
            },
            (resp) {
              if (!streamController.isClosed) {
                streamController?.sink?.add(Right(resp));
              }
            },
          ),
        );
      }

      return Right(streamController);
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

  Future<Either<Failure, Post>> _uploadInIsolate(post) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure());
    }

    try {
      await remoteDataSource.savePost(
        userId: post.userId,
        organizationId: post.organizationId,
        file: File(post.imageUrl),
        location: post.location,
        specie: post.specie,
      );

      await localDataSource.deletePost(post?.id);

      return Right(post);
    } on ServerException catch (exception) {
      return Left(ServerFailure(
        exception.message,
        exception.code,
        exception.origin,
        stackTrace: exception.stackTrace,
      ));
    } on NoInternetFailure catch (failure) {
      return Left(failure);
    } catch (error) {
      return Left(NoInternetFailure());
    }
  }
}
