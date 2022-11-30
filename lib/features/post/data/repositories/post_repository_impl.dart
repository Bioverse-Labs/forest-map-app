import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../../../../core/enums/exception_origin_types.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/platform/location.dart';
import '../../../../core/platform/network_info.dart';
import '../../../../core/util/uuid_generator.dart';
import '../../../catalog/domain/entities/catalog.dart';
import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/post_local_data_source.dart';
import '../datasources/post_remote_data_source.dart';
import '../models/post_model.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;
  final PostLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  final LocationUtils locationUtils;
  final UUIDGenerator uuidGenerator;

  PostRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
    @required this.locationUtils,
    @required this.uuidGenerator,
  });

  @override
  Future<Either<Failure, List<Post>>> savePost({
    @required String organizationId,
    @required String userId,
    @required File file,
    @required Catalog category,
  }) async {
    try {
      final hasPermission = await locationUtils.checkLocationPermission();
      final location = await locationUtils.getCurrentPosition(hasPermission);
      final post = PostModel(
        id: uuidGenerator.generateUID(),
        userId: userId,
        organizationId: organizationId,
        imageUrl: file.path,
        location: location,
        timestamp: DateTime.now(),
        category: category,
      );

      if (!await networkInfo.isConnected) {
        await localDataSource.savePost(post, isPendingPost: true);
      } else {
        await localDataSource.savePost(post);
        await remoteDataSource.savePost(post);
      }

      final localPosts = await localDataSource.getAllOrgPosts(organizationId);
      final localPendingPosts = await localDataSource.getAllOrgPosts(
        organizationId,
        isPendingPost: true,
      );
      return Right([...localPosts, ...localPendingPosts]);
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
      final posts = await localDataSource.getAllPosts(isPendingPost: true);
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

  Future<Either<Failure, Post>> _uploadInIsolate(PostModel post) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure());
    }

    try {
      await remoteDataSource.savePost(post);
      await localDataSource.deletePost(post?.id, isPendingPost: true);
      await localDataSource.savePost(post);

      return Right(post);
    } on ServerException catch (exception) {
      return Left(ServerFailure(
        exception.message,
        exception.code,
        exception.origin,
        stackTrace: exception.stackTrace,
      ));
    } on NoInternetFailure catch (_) {
      return Left(NoInternetFailure());
    } catch (error) {
      return Left(
        LocalFailure(
          error.toString(),
          '500',
          ExceptionOriginTypes.unkown,
          stackTrace: StackTrace.fromString(error.toString()),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<Post>>> getPosts({String orgId}) async {
    try {
      final localPosts = await localDataSource.getAllOrgPosts(orgId);
      final localPendingPosts = await localDataSource.getAllOrgPosts(
        orgId,
        isPendingPost: true,
      );

      if (!await networkInfo.isConnected) {
        return Right([...localPosts, ...localPendingPosts]);
      }

      final remotePosts = await remoteDataSource.getPosts(orgId: orgId);

      await localDataSource.syncPosts(remotePosts);

      return Right([...localPendingPosts, ...remotePosts]);
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
