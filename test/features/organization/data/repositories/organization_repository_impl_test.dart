import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:forest_map/core/enums/exception_origin_types.dart';
import 'package:forest_map/core/enums/organization_role_types.dart';
import 'package:forest_map/core/errors/exceptions.dart';
import 'package:forest_map/core/errors/failure.dart';
import 'package:forest_map/core/platform/network_info.dart';
import 'package:forest_map/features/organization/data/datasources/organization_local_data_source.dart';
import 'package:forest_map/features/user/data/models/user_model.dart';
import 'package:forest_map/features/organization/data/datasources/organization_remote_data_source.dart';
import 'package:forest_map/features/organization/data/models/organization_model.dart';
import 'package:forest_map/features/organization/data/repositories/organization_repository_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'organization_repository_impl_test.mocks.dart';

@GenerateMocks([
  OrganizationRemoteDataSource,
  OrganizationLocalDataSource,
  NetworkInfo,
])
void main() {
  late MockOrganizationRemoteDataSource mockOrganizationDataSource;
  late MockOrganizationLocalDataSource mockOrganizationLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late OrganizationRepositoryImpl organizationRepositoryImpl;

  setUp(() {
    mockOrganizationDataSource = MockOrganizationRemoteDataSource();
    mockOrganizationLocalDataSource = MockOrganizationLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    organizationRepositoryImpl = OrganizationRepositoryImpl(
      remoteDataSource: mockOrganizationDataSource,
      localDataSource: mockOrganizationLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final tId = faker.guid.guid();
  final tUserId = faker.guid.guid();
  final tName = faker.company.name();
  final tEmail = faker.internet.email();
  final tPhone = faker.randomGenerator.integer(20).toString();
  final tAvatarUrl = faker.image.image();
  final tAvatarFile = File(tAvatarUrl);
  final tUser = UserModel(id: tUserId, name: faker.person.name());
  final tOrganizationModel = OrganizationModel(
    id: tId,
    name: tName,
    email: tEmail,
    phone: tPhone,
    avatarUrl: tAvatarUrl,
  );

  final tErrorMessage = faker.randomGenerator.string(20);
  final tErrorCode = faker.randomGenerator.string(4);
  final tErrorOrigin = ExceptionOriginTypes.test;

  final tServerException = ServerException(
    tErrorMessage,
    tErrorCode,
    tErrorOrigin,
  );

  void runTestOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('createOrganization', () {
    runTestOnline(() {
      test(
        'should return [Organization] when datasource succeed',
        () async {
          when(mockOrganizationDataSource.createOrganization(
            user: anyNamed('user'),
            name: anyNamed('name'),
            email: anyNamed('email'),
            phone: anyNamed('phone'),
            avatar: anyNamed('avatar'),
          )).thenAnswer((_) async => tOrganizationModel);

          final result = await organizationRepositoryImpl.createOrganization(
            user: tUser,
            name: tName,
            email: tEmail,
            phone: tPhone,
            avatar: tAvatarFile,
          );

          expect(result, Right(tOrganizationModel));
          verify(mockOrganizationDataSource.createOrganization(
            user: tUser,
            name: tName,
            email: tEmail,
            phone: tPhone,
            avatar: tAvatarFile,
          ));
          verifyNoMoreInteractions(mockOrganizationDataSource);
        },
      );

      test(
        'should return [ServerFailure] when datasource fails',
        () async {
          when(mockOrganizationDataSource.createOrganization(
            user: anyNamed('user'),
            name: anyNamed('name'),
            email: anyNamed('email'),
            phone: anyNamed('phone'),
            avatar: anyNamed('avatar'),
          )).thenThrow(tServerException);

          final result = await organizationRepositoryImpl.createOrganization(
            user: tUser,
            name: tName,
            email: tEmail,
            phone: tPhone,
            avatar: tAvatarFile,
          );

          expect(
            result,
            Left(ServerFailure(
              tErrorMessage,
              tErrorCode,
              tErrorOrigin,
            )),
          );
          verify(mockOrganizationDataSource.createOrganization(
            user: tUser,
            name: tName,
            email: tEmail,
            phone: tPhone,
            avatar: tAvatarFile,
          ));
          verifyNoMoreInteractions(mockOrganizationDataSource);
        },
      );
    });

    runTestOffline(() {
      test(
        'should return [NoInternetFailure] user is not connected to the internet',
        () async {
          final result = await organizationRepositoryImpl.createOrganization(
            user: tUser,
            name: tName,
            email: tEmail,
            phone: tPhone,
            avatar: tAvatarFile,
          );

          expect(
            result,
            Left(NoInternetFailure()),
          );
          verifyZeroInteractions(mockOrganizationDataSource);
        },
      );
    });
  });

  group('getOrganization', () {
    runTestOnline(() {
      test(
        'should return [Organization] when datasource succeed',
        () async {
          when(mockOrganizationDataSource.getOrganization(any))
              .thenAnswer((_) async => tOrganizationModel);

          final result = await organizationRepositoryImpl.getOrganization(
            id: tId,
            searchLocally: false,
          );

          expect(result, Right(tOrganizationModel));
          verify(mockOrganizationDataSource.getOrganization(tId));
          verifyNoMoreInteractions(mockOrganizationDataSource);
        },
      );

      test(
        'should return [Organization] from local when datasource succeed',
        () async {
          when(mockOrganizationLocalDataSource.getOrganization(any))
              .thenAnswer((_) async => tOrganizationModel);

          final result = await organizationRepositoryImpl.getOrganization(
            id: tId,
            searchLocally: true,
          );

          expect(result, Right(tOrganizationModel));
          verify(mockOrganizationLocalDataSource.getOrganization(tId));
          verifyNoMoreInteractions(mockOrganizationDataSource);
        },
      );

      test(
        'should return [ServerFailure] when datasource fails',
        () async {
          when(mockOrganizationDataSource.getOrganization(any))
              .thenThrow(tServerException);

          final result = await organizationRepositoryImpl.getOrganization(
            id: tId,
            searchLocally: false,
          );

          expect(
            result,
            Left(ServerFailure(
              tErrorMessage,
              tErrorCode,
              tErrorOrigin,
            )),
          );
          verify(mockOrganizationDataSource.getOrganization(tId));
          verifyNoMoreInteractions(mockOrganizationDataSource);
        },
      );
    });

    runTestOffline(() {
      test(
        'should return [Organization] when datasource succeed',
        () async {
          when(mockOrganizationLocalDataSource.getOrganization(any))
              .thenAnswer((_) async => tOrganizationModel);

          final result = await organizationRepositoryImpl.getOrganization(
            id: tId,
            searchLocally: false,
          );

          expect(result, Right(tOrganizationModel));
          verify(mockOrganizationLocalDataSource.getOrganization(tId));
          verifyNoMoreInteractions(mockOrganizationLocalDataSource);
        },
      );

      test(
        'should return [LocalFailure] when datasource fails',
        () async {
          when(mockOrganizationLocalDataSource.getOrganization(any)).thenThrow(
            LocalException(
              tServerException.message,
              tServerException.code,
              tServerException.origin,
            ),
          );

          final result = await organizationRepositoryImpl.getOrganization(
            id: tId,
            searchLocally: false,
          );

          expect(
            result,
            Left(LocalFailure(
              tErrorMessage,
              tErrorCode,
              tErrorOrigin,
            )),
          );
          verify(mockOrganizationLocalDataSource.getOrganization(tId));
          verifyNoMoreInteractions(mockOrganizationLocalDataSource);
        },
      );
    });
  });

  group('updateOrganization', () {
    runTestOnline(() {
      test(
        'should return [Organization] when datasource succeed',
        () async {
          when(mockOrganizationDataSource.updateOrganization(
            id: anyNamed('id'),
            name: anyNamed('name'),
            email: anyNamed('email'),
            phone: anyNamed('phone'),
            avatar: anyNamed('avatar'),
          )).thenAnswer((_) async => tOrganizationModel);

          final result = await organizationRepositoryImpl.updateOrganization(
            id: tId,
            name: tName,
            email: tEmail,
            phone: tPhone,
            avatar: tAvatarFile,
          );

          expect(result, Right(tOrganizationModel));
          verify(mockOrganizationDataSource.updateOrganization(
            id: tId,
            name: tName,
            email: tEmail,
            phone: tPhone,
            avatar: tAvatarFile,
          ));
          verifyNoMoreInteractions(mockOrganizationDataSource);
        },
      );

      test(
        'should return [ServerFailure] when datasource fails',
        () async {
          when(mockOrganizationDataSource.updateOrganization(
            id: anyNamed('id'),
            name: anyNamed('name'),
            email: anyNamed('email'),
            phone: anyNamed('phone'),
            avatar: anyNamed('avatar'),
          )).thenThrow(tServerException);

          final result = await organizationRepositoryImpl.updateOrganization(
            id: tId,
            name: tName,
            email: tEmail,
            phone: tPhone,
            avatar: tAvatarFile,
          );

          expect(
            result,
            Left(ServerFailure(
              tErrorMessage,
              tErrorCode,
              tErrorOrigin,
            )),
          );
          verify(mockOrganizationDataSource.updateOrganization(
            id: anyNamed('id'),
            name: tName,
            email: tEmail,
            phone: tPhone,
            avatar: tAvatarFile,
          ));
          verifyNoMoreInteractions(mockOrganizationDataSource);
        },
      );
    });

    runTestOffline(() {
      test(
        'should return [NoInternetFailure] user is not connected to the internet',
        () async {
          final result = await organizationRepositoryImpl.updateOrganization(
            id: tId,
            name: tName,
            email: tEmail,
            phone: tPhone,
            avatar: tAvatarFile,
          );

          expect(
            result,
            Left(NoInternetFailure()),
          );
          verifyZeroInteractions(mockOrganizationDataSource);
        },
      );
    });
  });

  group('deleteOrganization', () {
    runTestOnline(() {
      test(
        'should delete organization if [id] is correct',
        () async {
          await organizationRepositoryImpl.deleteOrganization(tId);

          verify(mockOrganizationDataSource.deleteOrganization(tId));
          verifyNoMoreInteractions(mockOrganizationDataSource);
        },
      );

      test(
        'should return [ServerFailure] when datasource fails',
        () async {
          when(mockOrganizationDataSource.deleteOrganization(any))
              .thenThrow(tServerException);

          final result =
              await organizationRepositoryImpl.deleteOrganization(tId);

          expect(
            result,
            Left(ServerFailure(
              tErrorMessage,
              tErrorCode,
              tErrorOrigin,
            )),
          );
          verify(mockOrganizationDataSource.deleteOrganization(tId));
          verifyNoMoreInteractions(mockOrganizationDataSource);
        },
      );
    });

    runTestOffline(() {
      test(
        'should return [NoInternetFailure] user is not connected to the internet',
        () async {
          final result = await organizationRepositoryImpl.deleteOrganization(
            tId,
          );

          expect(
            result,
            Left(NoInternetFailure()),
          );
          verifyZeroInteractions(mockOrganizationDataSource);
        },
      );
    });
  });

  group('updateMember', () {
    runTestOnline(() {
      test(
        'should return [Organization] when datasource succeed',
        () async {
          when(mockOrganizationDataSource.updateMember(
            id: anyNamed('id'),
            userId: anyNamed('userId'),
            role: anyNamed('role'),
          )).thenAnswer((_) async => tOrganizationModel);

          final result = await organizationRepositoryImpl.updateMember(
            id: tId,
            userId: tUserId,
            role: OrganizationRoleType.admin,
          );

          expect(result, Right(tOrganizationModel));
          verify(mockOrganizationDataSource.updateMember(
            id: tId,
            userId: tUserId,
            role: OrganizationRoleType.admin,
          ));
          verifyNoMoreInteractions(mockOrganizationDataSource);
        },
      );

      test(
        'should return [ServerFailure] when datasource fails',
        () async {
          when(mockOrganizationDataSource.updateMember(
            id: anyNamed('id'),
            userId: anyNamed('userId'),
            role: anyNamed('role'),
          )).thenThrow(tServerException);

          final result = await organizationRepositoryImpl.updateMember(
            id: tId,
            userId: tUserId,
            role: OrganizationRoleType.admin,
          );

          expect(
            result,
            Left(ServerFailure(
              tErrorMessage,
              tErrorCode,
              tErrorOrigin,
            )),
          );
          verify(mockOrganizationDataSource.updateMember(
            id: tId,
            userId: tUserId,
            role: OrganizationRoleType.admin,
          ));
          verifyNoMoreInteractions(mockOrganizationDataSource);
        },
      );
    });

    runTestOffline(() {
      test(
        'should return [NoInternetFailure] user is not connected to the internet',
        () async {
          final result = await organizationRepositoryImpl.updateMember(
            id: tId,
            userId: tUserId,
            role: OrganizationRoleType.member,
          );

          expect(
            result,
            Left(NoInternetFailure()),
          );
          verifyZeroInteractions(mockOrganizationDataSource);
        },
      );
    });
  });

  group('removeMember', () {
    runTestOnline(() {
      test(
        'should return [Organization] when datasource succeed',
        () async {
          when(mockOrganizationDataSource.removeMember(
            id: anyNamed('id'),
            userId: anyNamed('userId'),
          )).thenAnswer((_) async => tOrganizationModel);

          final result = await organizationRepositoryImpl.removeMember(
            id: tId,
            userId: tUserId,
          );

          expect(result, Right(tOrganizationModel));
          verify(mockOrganizationDataSource.removeMember(
            id: tId,
            userId: tUserId,
          ));
          verifyNoMoreInteractions(mockOrganizationDataSource);
        },
      );

      test(
        'should return [ServerFailure] when datasource fails',
        () async {
          when(mockOrganizationDataSource.removeMember(
            id: anyNamed('id'),
            userId: anyNamed('userId'),
          )).thenThrow(tServerException);

          final result = await organizationRepositoryImpl.removeMember(
            id: tId,
            userId: tUserId,
          );

          expect(
            result,
            Left(ServerFailure(
              tErrorMessage,
              tErrorCode,
              tErrorOrigin,
            )),
          );
          verify(mockOrganizationDataSource.removeMember(
            id: tId,
            userId: tUserId,
          ));
          verifyNoMoreInteractions(mockOrganizationDataSource);
        },
      );
    });

    runTestOffline(() {
      test(
        'should return [NoInternetFailure] user is not connected to the internet',
        () async {
          final result = await organizationRepositoryImpl.removeMember(
            id: tId,
            userId: tUserId,
          );

          expect(
            result,
            Left(NoInternetFailure()),
          );
          verifyZeroInteractions(mockOrganizationDataSource);
        },
      );
    });
  });

  group('saveOrganizationLocally', () {
    test(
      'should save [Organization] local storage',
      () async {
        when(mockOrganizationLocalDataSource.saveOrganization(
          id: anyNamed('id'),
          organization: anyNamed('organization'),
        )).thenAnswer((_) async => null);

        await organizationRepositoryImpl.saveOrganizationLocally(
          id: tOrganizationModel.id,
          organization: tOrganizationModel,
        );

        verify(mockOrganizationLocalDataSource.saveOrganization(
          id: tOrganizationModel.id,
          organization: tOrganizationModel,
        ));
        verifyNoMoreInteractions(mockOrganizationLocalDataSource);
      },
    );

    test(
      'should return [LocalFailure] if datasource fails',
      () async {
        when(mockOrganizationLocalDataSource.saveOrganization(
          id: anyNamed('id'),
          organization: anyNamed('organization'),
        )).thenThrow(LocalException(
          tErrorMessage,
          tErrorCode,
          tErrorOrigin,
        ));

        final result = await organizationRepositoryImpl.saveOrganizationLocally(
          id: tOrganizationModel.id,
          organization: tOrganizationModel,
        );

        expect(
          result,
          Left(
            LocalFailure(
              tErrorMessage,
              tErrorCode,
              tErrorOrigin,
            ),
          ),
        );
        verify(mockOrganizationLocalDataSource.saveOrganization(
          id: tOrganizationModel.id,
          organization: tOrganizationModel,
        ));
        verifyNoMoreInteractions(mockOrganizationLocalDataSource);
      },
    );
  });
}
