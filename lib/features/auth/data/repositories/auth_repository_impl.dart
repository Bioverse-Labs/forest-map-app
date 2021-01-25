import 'package:dartz/dartz.dart';

import '../../../../core/enums/social_login_types.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/platform/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource dataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl(this.dataSource, this.networkInfo);

  @override
  Future<Either<Failure, User>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure());
    }

    try {
      return Right(
        await dataSource.signInWithEmailAndPassword(email, password),
      );
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message, error.code, error.origin));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithSocial(SocialLoginType type) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure());
    }

    try {
      return Right(await dataSource.signInWithSocial(type));
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message, error.code, error.origin));
    }
  }

  @override
  Future<Either<Failure, User>> signUp(
    String name,
    String email,
    String password,
  ) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure());
    }

    try {
      return Right(await dataSource.signUp(name, email, password));
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message, error.code, error.origin));
    }
  }
}
