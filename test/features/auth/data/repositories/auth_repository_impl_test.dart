import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:forest_map_app/core/adapters/hive_adapter.dart';
import 'package:forest_map_app/core/enums/exception_origin_types.dart';
import 'package:forest_map_app/core/enums/organization_member_status.dart';
import 'package:forest_map_app/core/enums/organization_role_types.dart';
import 'package:forest_map_app/core/enums/social_login_types.dart';
import 'package:forest_map_app/core/errors/exceptions.dart';
import 'package:forest_map_app/core/errors/failure.dart';
import 'package:forest_map_app/core/platform/network_info.dart';
import 'package:forest_map_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:forest_map_app/features/organization/data/datasources/organization_local_data_source.dart';
import 'package:forest_map_app/features/organization/data/hive/organization.dart';
import 'package:forest_map_app/features/organization/data/models/member_model.dart';
import 'package:forest_map_app/features/organization/data/models/organization_model.dart';
import 'package:forest_map_app/features/user/data/datasource/user_local_data_source.dart';
import 'package:forest_map_app/features/user/data/datasource/user_remote_data_source.dart';
import 'package:forest_map_app/features/user/data/hive/user.dart';
import 'package:forest_map_app/features/user/data/models/user_model.dart';
import 'package:forest_map_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:forest_map_app/features/user/domain/entities/user.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockUserRemoteDataSource extends Mock implements UserRemoteDataSource {}

class MockUserLocalDataSource extends Mock implements UserLocalDataSource {}

class MockOrganizationLocalDataSource extends Mock
    implements OrganizationLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockUserHive extends Mock implements HiveAdapter<UserHive> {}

class MockOrgHive extends Mock implements HiveAdapter<OrganizationHive> {}

void main() {
  AuthRepositoryImpl repository;
  MockRemoteDataSource dataSource;
  MockUserRemoteDataSource userRemoteDataSource;
  MockUserLocalDataSource userLocalDataSource;
  MockOrganizationLocalDataSource mockOrganizationLocalDataSource;
  MockNetworkInfo networkInfo;

  setUp(() {
    dataSource = MockRemoteDataSource();
    userRemoteDataSource = MockUserRemoteDataSource();
    userLocalDataSource = MockUserLocalDataSource();
    mockOrganizationLocalDataSource = MockOrganizationLocalDataSource();
    networkInfo = MockNetworkInfo();
    repository = AuthRepositoryImpl(
      authDataSource: dataSource,
      userRemoteDataSource: userRemoteDataSource,
      userLocalDataSource: userLocalDataSource,
      organizationLocalDataSource: mockOrganizationLocalDataSource,
      networkInfo: networkInfo,
    );
  });

  final userId = faker.guid.guid();
  final name = faker.person.name();
  final email = faker.internet.email();
  final password = faker.internet.password();
  final avatarUrl = faker.internet.uri('protocol');
  final errorMessage = faker.randomGenerator.string(10);
  final errorCode = faker.randomGenerator.string(3);
  final tOrganizationModel = OrganizationModel(
    id: faker.guid.guid(),
    name: faker.company.name(),
    email: faker.internet.email(),
    members: [
      MemberModel(
        id: userId,
        name: name,
        email: email,
        avatarUrl: avatarUrl,
        role: OrganizationRoleType.owner,
        status: OrganizationMemberStatus.active,
      )
    ],
  );
  final tUserModel = UserModel(
    id: userId,
    name: name,
    email: email,
    avatarUrl: avatarUrl,
    organizations: [tOrganizationModel],
  );
  final User tUser = tUserModel;

  void runTestOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('signInWithEmailAndPassword', () {
    test('should check if device is online', () async {
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      when(dataSource.signInWithEmailAndPassword(any, any))
          .thenAnswer((_) async => tUserModel);
      when(userRemoteDataSource.getUser(any))
          .thenAnswer((_) async => tUserModel);

      repository.signInWithEmailAndPassword(email, password);
      verify(networkInfo.isConnected);
    });

    runTestOnline(() {
      test(
        'should return UserModel when remote data source is successful',
        () async {
          when(dataSource.signInWithEmailAndPassword(any, any))
              .thenAnswer((_) async => tUserModel);
          when(userRemoteDataSource.getUser(any))
              .thenAnswer((_) async => tUserModel);

          final result = await repository.signInWithEmailAndPassword(
            email,
            password,
          );

          verify(dataSource.signInWithEmailAndPassword(email, password));
          expect(result, equals(Right(tUser)));
        },
      );

      test(
        'should return ServerFailure when remote data source is unsuccessful',
        () async {
          when(dataSource.signInWithEmailAndPassword(any, any)).thenThrow(
            ServerException(
              errorMessage,
              errorCode,
              ExceptionOriginTypes.test,
            ),
          );

          final result =
              await repository.signInWithEmailAndPassword(email, password);

          verify(dataSource.signInWithEmailAndPassword(email, password));
          expect(
            result,
            equals(
              Left(
                ServerFailure(
                  errorMessage,
                  errorCode,
                  ExceptionOriginTypes.test,
                ),
              ),
            ),
          );
          verifyNoMoreInteractions(dataSource);
        },
      );
    });

    runTestOffline(() {
      test('should return NoInternetFailure when device is offline', () async {
        final result =
            await repository.signInWithEmailAndPassword(email, password);

        verifyNever(dataSource.signInWithEmailAndPassword(email, password));
        expect(
          result,
          equals(Left(NoInternetFailure())),
        );
      });
    });
  });

  group('signInWithSocial', () {
    test('should check if device is online', () async {
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      when(dataSource.signInWithSocial(any))
          .thenAnswer((_) async => tUserModel);
      when(userRemoteDataSource.getUser(any))
          .thenAnswer((_) async => tUserModel);

      repository.signInWithSocial(SocialLoginType.facebook);
      verify(networkInfo.isConnected);
    });

    runTestOnline(() {
      test(
        'should return UserModel when remote data source is successful',
        () async {
          when(dataSource.signInWithSocial(any))
              .thenAnswer((_) async => tUserModel);
          when(userRemoteDataSource.getUser(any))
              .thenAnswer((_) async => tUserModel);

          final result =
              await repository.signInWithSocial(SocialLoginType.facebook);

          verify(dataSource.signInWithSocial(SocialLoginType.facebook));
          expect(result, equals(Right(tUser)));
        },
      );

      test(
        'should return ServerFailure when remote data source is unsuccessful',
        () async {
          when(dataSource.signInWithSocial(any)).thenThrow(
            ServerException(
              errorMessage,
              errorCode,
              ExceptionOriginTypes.test,
            ),
          );

          final result =
              await repository.signInWithSocial(SocialLoginType.google);

          verify(dataSource.signInWithSocial(SocialLoginType.google));
          expect(
            result,
            equals(
              Left(
                ServerFailure(
                  errorMessage,
                  errorCode,
                  ExceptionOriginTypes.test,
                ),
              ),
            ),
          );
          verifyNoMoreInteractions(dataSource);
        },
      );
    });

    runTestOffline(() {
      test(
        'should return NoInternetFailure when device is offline',
        () async {
          final result =
              await repository.signInWithSocial(SocialLoginType.facebook);

          expect(result, equals(Left(NoInternetFailure())));
        },
      );
    });
  });

  group('signUp', () {
    test('should check if device is online', () async {
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      when(dataSource.signUp(any, any, any))
          .thenAnswer((_) async => tUserModel);
      when(userRemoteDataSource.getUser(any))
          .thenAnswer((_) async => tUserModel);

      repository.signUp(name, email, password);
      verify(networkInfo.isConnected);
    });

    runTestOnline(() {
      test(
        'should return UserModel when remote data source is successful',
        () async {
          when(dataSource.signUp(any, any, any))
              .thenAnswer((_) async => tUserModel);
          when(userRemoteDataSource.getUser(any))
              .thenAnswer((_) async => tUserModel);

          final result = await repository.signUp(name, email, password);

          verify(dataSource.signUp(name, email, password));
          expect(result, equals(Right(tUser)));
        },
      );

      test(
        'should return ServerFailure when remote data source is unsuccessful',
        () async {
          when(dataSource.signUp(any, any, any)).thenThrow(
            ServerException(
              errorMessage,
              errorCode,
              ExceptionOriginTypes.test,
            ),
          );

          final result = await repository.signUp(name, email, password);

          verify(dataSource.signUp(name, email, password));
          expect(
            result,
            equals(
              Left(
                ServerFailure(
                  errorMessage,
                  errorCode,
                  ExceptionOriginTypes.test,
                ),
              ),
            ),
          );
          verifyNoMoreInteractions(dataSource);
        },
      );
    });

    runTestOffline(() {
      test(
        'should return NoInternetFailure when device is offline',
        () async {
          final result = await repository.signUp(name, email, password);

          expect(result, equals(Left(NoInternetFailure())));
        },
      );
    });
  });

  group('SignOut', () {
    test(
      'should signOut',
      () async {
        when(dataSource.signOut()).thenAnswer((_) async => null);

        final result = await repository.signOut();

        expect(result, isInstanceOf<Right>());
      },
    );

    test(
      'should return [ServerFailure]',
      () async {
        when(dataSource.signOut()).thenThrow(ServerException(
          errorMessage,
          errorCode,
          ExceptionOriginTypes.test,
        ));

        final result = await repository.signOut();

        expect(
          result,
          equals(
            Left(
              ServerFailure(
                errorMessage,
                errorCode,
                ExceptionOriginTypes.test,
              ),
            ),
          ),
        );
      },
    );

    test(
      'should return [LocalFailure]',
      () async {
        when(dataSource.signOut()).thenThrow(LocalException(
          errorMessage,
          errorCode,
          ExceptionOriginTypes.test,
        ));

        final result = await repository.signOut();

        expect(
          result,
          equals(
            Left(
              LocalFailure(
                errorMessage,
                errorCode,
                ExceptionOriginTypes.test,
              ),
            ),
          ),
        );
      },
    );

    test(
      'should signOut',
      () async {
        when(dataSource.signOut()).thenAnswer((_) async => null);

        final result = await repository.signOut();

        expect(result, isInstanceOf<Right>());
      },
    );
  });
}
