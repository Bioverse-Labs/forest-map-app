import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/adapters/hive_adapter.dart';
import '../../../../core/enums/social_login_types.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/platform/network_info.dart';
import '../../../organization/data/hive/member.dart';
import '../../../organization/data/hive/organization.dart';
import '../../../user/data/datasource/user_remote_data_source.dart';
import '../../../user/data/hive/user.dart';
import '../../../user/domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

typedef Future<User> _DSExecutor();

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authDataSource;
  final UserRemoteDataSource userDataSource;
  final HiveAdapter<UserHive> userHive;
  final HiveAdapter<OrganizationHive> orgHive;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    @required this.authDataSource,
    @required this.userDataSource,
    @required this.networkInfo,
    @required this.userHive,
    @required this.orgHive,
  });

  @override
  Future<Either<Failure, User>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async =>
      _getUser(
        () => authDataSource.signInWithEmailAndPassword(email, password),
      );

  @override
  Future<Either<Failure, User>> signInWithSocial(SocialLoginType type) async =>
      _getUser(() => authDataSource.signInWithSocial(type));

  @override
  Future<Either<Failure, User>> signUp(
    String name,
    String email,
    String password,
  ) async =>
      _getUser(() => authDataSource.signUp(name, email, password));

  Future<Either<Failure, User>> _getUser(_DSExecutor dataSourceExecutor) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure());
    }

    try {
      final authModel = await dataSourceExecutor();
      final userModel = await userDataSource.getUser(authModel.id);

      // SAVE USER TO HIVE
      final userObject = UserHive()
        ..id = userModel.id
        ..name = userModel.name
        ..email = userModel.email
        ..avatarUrl = userModel.avatarUrl;

      if (userModel.organizations != null &&
          userModel.organizations.length > 0) {
        final organizationObjects = userModel.organizations.map((organization) {
          final members = organization?.members
              ?.map<MemberHive>(
                (member) => MemberHive()
                  ..id = member.id
                  ..name = member.name
                  ..email = member.email
                  ..avatarUrl = member.avatarUrl
                  ..status = member.status
                  ..role = member.role,
              )
              ?.toList();

          return OrganizationHive()
            ..id = organization.id
            ..name = organization.name
            ..email = organization.email
            ..phone = organization.phone
            ..avatarUrl = organization.avatarUrl
            ..members = members;
        }).toList();
        await orgHive.put(
          'currOrg',
          organizationObjects.first,
        );
        userObject..organizations = organizationObjects;
      }
      await userHive.put(userModel.id, userObject);

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
      return Right(await authDataSource.signOut());
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
}
