import 'package:dartz/dartz.dart';
import '../../../../core/enums/exception_origin_types.dart';

import '../../../../core/enums/social_login_types.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/platform/network_info.dart';
import '../../../organization/data/datasources/organization_local_data_source.dart';
import '../../../user/data/datasource/user_local_data_source.dart';
import '../../../user/data/datasource/user_remote_data_source.dart';
import '../../../user/domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

typedef Future<User?> _DSExecutor();

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource? authDataSource;
  final UserRemoteDataSource? userRemoteDataSource;
  final UserLocalDataSource? userLocalDataSource;
  final OrganizationLocalDataSource? organizationLocalDataSource;
  final NetworkInfo? networkInfo;

  AuthRepositoryImpl({
    required this.authDataSource,
    required this.userRemoteDataSource,
    required this.userLocalDataSource,
    required this.organizationLocalDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async =>
      _getUser(
        () => authDataSource!.signInWithEmailAndPassword(email, password),
      );

  @override
  Future<Either<Failure, User>> signInWithSocial(SocialLoginType type) async =>
      _getUser(() => authDataSource!.signInWithSocial(type));

  @override
  Future<Either<Failure, User>> signUp(
    String name,
    String email,
    String password,
  ) async =>
      _getUser(() => authDataSource!.signUp(name, email, password));

  Future<Either<Failure, User>> _getUser(_DSExecutor dataSourceExecutor) async {
    if (!await networkInfo!.isConnected) {
      return Left(NoInternetFailure());
    }

    try {
      final authModel = await dataSourceExecutor();
      final userModel = await userRemoteDataSource!.getUser(authModel?.id);

      await userLocalDataSource!.saveUser(id: 'currUser', user: userModel);

      if (userModel.organizations != null &&
          userModel.organizations!.length > 0) {
        await organizationLocalDataSource!.saveOrganization(
          id: 'currOrg',
          organization: userModel.organizations!.first,
        );
      }

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
  Future<Either<Failure, void>> signOut() async {
    try {
      return Right(await authDataSource!.signOut());
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
  Future<Either<Failure, void>> forgotPassword(String email) async {
    try {
      await authDataSource!.forgotPassword(email);
      return Right(null);
    } on ServerException catch (error) {
      return Left(ServerFailure(
        error.message,
        error.code,
        error.origin,
        stackTrace: error.stackTrace,
      ));
    } catch (error) {
      return Left(LocalFailure(
        error.toString(),
        '500',
        ExceptionOriginTypes.unkown,
      ));
    }
  }
}
