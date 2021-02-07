import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../organization/domain/entities/organization.dart';
import '../../domain/entities/user.dart';
import '../../domain/repository/user_repository.dart';
import '../datasource/user_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSource dataSource;

  UserRepositoryImpl({
    @required this.dataSource,
  });

  @override
  Future<Either<Failure, User>> getUser(String id) async {
    try {
      return Right(await dataSource.getUser(id));
    } on ServerException catch (error) {
      return Left(ServerFailure(
        error.message,
        error.code,
        error.origin,
        stackTrace: error.stackTrace,
      ));
    }
  }

  @override
  Future<Either<Failure, User>> updateUser({
    @required String id,
    String name,
    String email,
    List<Organization> organizations,
    File avatar,
  }) async {
    try {
      return Right(await dataSource.updateUser(
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
