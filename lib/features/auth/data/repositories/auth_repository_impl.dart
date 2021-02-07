import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/enums/social_login_types.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/platform/network_info.dart';
import '../../../user/domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

typedef Future<User> _DSExecutor();

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource dataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    @required this.dataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async =>
      _getUser(() => dataSource.signInWithEmailAndPassword(email, password));

  @override
  Future<Either<Failure, User>> signInWithSocial(SocialLoginType type) async =>
      _getUser(() => dataSource.signInWithSocial(type));

  @override
  Future<Either<Failure, User>> signUp(
    String name,
    String email,
    String password,
  ) async =>
      _getUser(() => dataSource.signUp(name, email, password));

  Future<Either<Failure, User>> _getUser(_DSExecutor dataSourceExecutor) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure());
    }

    try {
      return Right(await dataSourceExecutor());
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
