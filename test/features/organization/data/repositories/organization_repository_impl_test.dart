import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:forestMapApp/core/enums/exception_origin_types.dart';
import 'package:forestMapApp/core/enums/organization_role_types.dart';
import 'package:forestMapApp/core/errors/exceptions.dart';
import 'package:forestMapApp/core/errors/failure.dart';
import 'package:forestMapApp/features/auth/data/models/user_model.dart';
import 'package:forestMapApp/features/organization/data/datasources/organization_data_source.dart';
import 'package:forestMapApp/features/organization/data/models/organization_model.dart';
import 'package:forestMapApp/features/organization/data/repositories/organization_repository_impl.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockOrganizationDataSource extends Mock
    implements OrganizationDataSource {}

void main() {
  MockOrganizationDataSource mockOrganizationDataSource;
  OrganizationRepositoryImpl organizationRepositoryImpl;

  setUp(() {
    mockOrganizationDataSource = MockOrganizationDataSource();
    organizationRepositoryImpl =
        OrganizationRepositoryImpl(mockOrganizationDataSource);
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

  group('createOrganization', () {
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

  group('getOrganization', () {
    test(
      'should return [Organization] when datasource succeed',
      () async {
        when(mockOrganizationDataSource.getOrganization(any))
            .thenAnswer((_) async => tOrganizationModel);

        final result = await organizationRepositoryImpl.getOrganization(tId);

        expect(result, Right(tOrganizationModel));
        verify(mockOrganizationDataSource.getOrganization(tId));
        verifyNoMoreInteractions(mockOrganizationDataSource);
      },
    );

    test(
      'should return [ServerFailure] when datasource fails',
      () async {
        when(mockOrganizationDataSource.getOrganization(any))
            .thenThrow(tServerException);

        final result = await organizationRepositoryImpl.getOrganization(tId);

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

  group('updateOrganization', () {
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

  group('deleteOrganization', () {
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

        final result = await organizationRepositoryImpl.deleteOrganization(tId);

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

  group('inviteUserToOrganization', () {
    test(
      'should return [Organization] when datasource succeed',
      () async {
        when(mockOrganizationDataSource.inviteUserToOrganization(
          id: anyNamed('id'),
          user: anyNamed('user'),
        )).thenAnswer((_) async => tOrganizationModel);

        final result =
            await organizationRepositoryImpl.inviteUserToOrganization(
          id: tId,
          user: tUser,
        );

        expect(result, Right(tOrganizationModel));
        verify(mockOrganizationDataSource.inviteUserToOrganization(
          id: tId,
          user: tUser,
        ));
        verifyNoMoreInteractions(mockOrganizationDataSource);
      },
    );

    test(
      'should return [ServerFailure] when datasource fails',
      () async {
        when(mockOrganizationDataSource.inviteUserToOrganization(
          id: anyNamed('id'),
          user: anyNamed('user'),
        )).thenThrow(tServerException);

        final result =
            await organizationRepositoryImpl.inviteUserToOrganization(
          id: tId,
          user: tUser,
        );

        expect(
          result,
          Left(ServerFailure(
            tErrorMessage,
            tErrorCode,
            tErrorOrigin,
          )),
        );
        verify(mockOrganizationDataSource.inviteUserToOrganization(
          id: tId,
          user: tUser,
        ));
        verifyNoMoreInteractions(mockOrganizationDataSource);
      },
    );
  });

  group('updateMember', () {
    test(
      'should return [Organization] when datasource succeed',
      () async {
        when(mockOrganizationDataSource.updateMember(
          id: anyNamed('id'),
          userId: anyNamed('userId'),
          type: anyNamed('type'),
        )).thenAnswer((_) async => tOrganizationModel);

        final result = await organizationRepositoryImpl.updateMember(
          id: tId,
          userId: tUserId,
          type: OrganizationRoleType.admin,
        );

        expect(result, Right(tOrganizationModel));
        verify(mockOrganizationDataSource.updateMember(
          id: tId,
          userId: tUserId,
          type: OrganizationRoleType.admin,
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
          type: anyNamed('type'),
        )).thenThrow(tServerException);

        final result = await organizationRepositoryImpl.updateMember(
          id: tId,
          userId: tUserId,
          type: OrganizationRoleType.admin,
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
          type: OrganizationRoleType.admin,
        ));
        verifyNoMoreInteractions(mockOrganizationDataSource);
      },
    );
  });

  group('removeMember', () {
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
}
