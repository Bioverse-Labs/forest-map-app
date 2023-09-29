import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/platform/network_info.dart';
import '../../../organization/domain/entities/organization.dart';
import '../../domain/entities/user.dart';
import '../../domain/repository/user_repository.dart';
import '../datasource/user_local_data_source.dart';
import '../datasource/user_remote_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource? remoteDataSource;
  final UserLocalDataSource? localDataSource;
  final NetworkInfo? networkInfo;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User?>> getUser({
    String? id,
    bool? searchLocally,
  }) async {
    try {
      if (searchLocally! || !await networkInfo!.isConnected) {
        return Right(await localDataSource!.getUser(id));
      }
      final userModel = await remoteDataSource!.getUser(id);
      await localDataSource!.saveUser(
        id: 'currUser',
        user: userModel,
      );
      return Right(userModel);
    } on ServerException catch (error) {
      return Left(ServerFailure(
        error.message,
        error.code,
        error.origin,
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
  Future<Either<Failure, User>> updateUser({
    String? id,
    String? name,
    String? email,
    List<Organization>? organizations,
    File? avatar,
  }) async {
    try {
      if (!await networkInfo!.isConnected) {
        return Left(NoInternetFailure());
      }

      return Right(await remoteDataSource!.updateUser(
        id: id,
        name: name,
        email: email,
        organizations: organizations,
        avatar: avatar,
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
