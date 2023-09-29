import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forest_map/core/enums/exception_origin_types.dart';
import 'package:forest_map/core/enums/organization_member_status.dart';
import 'package:forest_map/core/enums/organization_role_types.dart';
import 'package:forest_map/core/errors/failure.dart';
import 'package:forest_map/features/organization/domain/usecases/save_organization_locally.dart';
import 'package:forest_map/features/user/domain/entities/user.dart';
import 'package:forest_map/features/organization/domain/entities/organization.dart';
import 'package:forest_map/features/organization/domain/usecases/create_organization.dart';
import 'package:forest_map/features/organization/domain/usecases/delete_organization.dart';
import 'package:forest_map/features/organization/domain/usecases/get_organization.dart';
import 'package:forest_map/features/organization/domain/usecases/remove_member.dart';
import 'package:forest_map/features/organization/domain/usecases/update_member.dart';
import 'package:forest_map/features/organization/domain/usecases/update_organization.dart';
import 'package:forest_map/features/organization/presentation/notifiers/organizations_notifier.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../core/notifiers/change_notifiers.dart';

import 'organization_notifier_test.mocks.dart';

@GenerateMocks([
  CreateOrganization,
  GetOrganization,
  UpdateOrganization,
  DeleteOrganization,
  UpdateMember,
  RemoveMember,
  SaveOrganizationLocally,
])
void main() {
  late MockCreateOrganization mockCreateOrganization;
  late MockGetOrganization mockGetOrganization;
  late MockUpdateOrganization mockUpdateOrganization;
  late MockDeleteOrganization mockDeleteOrganization;
  late MockUpdateMember mockUpdateMember;
  late MockRemoveMember mockRemoveMember;
  late MockSaveOrganizationLocally mockSaveOrganizationLocally;
  late OrganizationNotifierImpl organizationNotifierImpl;

  setUp(() {
    mockCreateOrganization = MockCreateOrganization();
    mockGetOrganization = MockGetOrganization();
    mockUpdateOrganization = MockUpdateOrganization();
    mockDeleteOrganization = MockDeleteOrganization();
    mockUpdateMember = MockUpdateMember();
    mockRemoveMember = MockRemoveMember();
    mockSaveOrganizationLocally = MockSaveOrganizationLocally();
    organizationNotifierImpl = OrganizationNotifierImpl(
      createOrganizationUseCase: mockCreateOrganization,
      getOrganizationUseCase: mockGetOrganization,
      updateOrganizationUseCase: mockUpdateOrganization,
      deleteOrganizationUseCase: mockDeleteOrganization,
      updateMemberUseCase: mockUpdateMember,
      removeMemberUseCase: mockRemoveMember,
      saveOrganizationLocallyUseCase: mockSaveOrganizationLocally,
    );
  });

  final tId = faker.guid.guid();
  final tName = faker.company.name();
  final tEmail = faker.internet.email();
  final tPhone = faker.randomGenerator.string(20);
  final tOrganization = Organization(
    id: tId,
    name: tName,
    email: tEmail,
    phone: tPhone,
  );

  final tUserId = faker.guid.guid();
  final tUserName = faker.person.name();
  final tUser = User(id: tUserId, name: tUserName);

  final tErrorMessage = faker.randomGenerator.string(20);
  final tErrorCode = faker.randomGenerator.string(20);
  final tFailure = ServerFailure(
    tErrorMessage,
    tErrorCode,
    ExceptionOriginTypes.test,
  );
  final tLocalFailure = LocalFailure(
    tErrorMessage,
    tErrorCode,
    ExceptionOriginTypes.test,
  );

  group('createOrganization', () {
    test(
      'should set [Organization] and notify all listeners if useCase succeed',
      () async {
        when(mockCreateOrganization(any))
            .thenAnswer((_) async => Right(tOrganization));

        await expectToNotifiyListener<OrganizationNotifierImpl>(
          organizationNotifierImpl,
          () => organizationNotifierImpl.createOrganization(
            user: tUser,
            name: tName,
            email: tEmail,
            phone: tPhone,
          ),
          [
            NotifierAssertParams(
              value: (notifier) => notifier.isLoading,
              matcher: true,
            ),
            NotifierAssertParams(
              value: (notifier) => notifier.isLoading,
              matcher: false,
            ),
            NotifierAssertParams(
              value: (notifier) => notifier.organization,
              matcher: tOrganization,
            ),
          ],
        );
        verify(mockCreateOrganization(CreateOrganizationParams(
          user: tUser,
          name: tName,
          email: tEmail,
          phone: tPhone,
        )));
        verifyNoMoreInteractions(mockCreateOrganization);
      },
    );

    test(
      'should throw [Failure] if useCase fails',
      () async {
        when(mockCreateOrganization(any))
            .thenAnswer((_) async => Left(tFailure));

        final call = organizationNotifierImpl.createOrganization;

        expect(
          () => call(
            user: tUser,
            name: tName,
            email: tEmail,
            phone: tPhone,
          ),
          throwsA(isInstanceOf<ServerFailure>()),
        );

        verify(mockCreateOrganization(CreateOrganizationParams(
          user: tUser,
          name: tName,
          email: tEmail,
          phone: tPhone,
        )));
        verifyNoMoreInteractions(mockCreateOrganization);
      },
    );
  });

  group('getOrganization', () {
    test(
      'should set [Organization] and notify all listeners if useCase succeed',
      () async {
        when(mockGetOrganization(any))
            .thenAnswer((_) async => Right(tOrganization));

        await expectToNotifiyListener<OrganizationNotifierImpl>(
          organizationNotifierImpl,
          () => organizationNotifierImpl.getOrganization(id: tId),
          [
            NotifierAssertParams(
              value: (notifier) => notifier.isLoading,
              matcher: true,
            ),
            NotifierAssertParams(
              value: (notifier) => notifier.isLoading,
              matcher: false,
            ),
            NotifierAssertParams(
              value: (notifier) => notifier.organization,
              matcher: tOrganization,
            ),
          ],
        );
        verify(mockGetOrganization(GetOrganizationParams(
          id: tId,
          searchLocally: false,
        )));
        verifyNoMoreInteractions(mockGetOrganization);
      },
    );

    test(
      'should throw [Failure] if useCase fails',
      () async {
        when(mockGetOrganization(any)).thenAnswer((_) async => Left(tFailure));

        final call = organizationNotifierImpl.getOrganization;

        expect(
          () => call(id: tId),
          throwsA(isInstanceOf<ServerFailure>()),
        );

        verify(mockGetOrganization(GetOrganizationParams(
          id: tId,
          searchLocally: false,
        )));
        verifyNoMoreInteractions(mockGetOrganization);
      },
    );
  });

  group('updateOrganization', () {
    test(
      'should set [Organization] and notify all listeners if useCase succeed',
      () async {
        when(mockUpdateOrganization(any))
            .thenAnswer((_) async => Right(tOrganization));

        await expectToNotifiyListener<OrganizationNotifierImpl>(
          organizationNotifierImpl,
          () => organizationNotifierImpl.updateOrganization(
            id: tId,
            name: tName,
            email: tEmail,
            phone: tPhone,
          ),
          [
            NotifierAssertParams(
              value: (notifier) => notifier.isLoading,
              matcher: true,
            ),
            NotifierAssertParams(
              value: (notifier) => notifier.isLoading,
              matcher: false,
            ),
            NotifierAssertParams(
              value: (notifier) => notifier.organization,
              matcher: tOrganization,
            ),
          ],
        );
        verify(mockUpdateOrganization(UpdateOrganizationParams(
          id: tId,
          name: tName,
          email: tEmail,
          phone: tPhone,
        )));
        verifyNoMoreInteractions(mockUpdateOrganization);
      },
    );

    test(
      'should throw [Failure] if useCase fails',
      () async {
        when(mockUpdateOrganization(any))
            .thenAnswer((_) async => Left(tFailure));

        final call = organizationNotifierImpl.updateOrganization;

        expect(
          () => call(
            id: tId,
            name: tName,
            email: tEmail,
            phone: tPhone,
          ),
          throwsA(isInstanceOf<ServerFailure>()),
        );

        verify(mockUpdateOrganization(UpdateOrganizationParams(
          id: tId,
          name: tName,
          email: tEmail,
          phone: tPhone,
        )));
        verifyNoMoreInteractions(mockUpdateOrganization);
      },
    );
  });

  group('deleteOrganization', () {
    test(
      'should remove [Organization] and notify all listeners if useCase succeed',
      () async {
        when(mockDeleteOrganization(any)).thenAnswer((_) async => Right(null));

        await expectToNotifiyListener<OrganizationNotifierImpl>(
          organizationNotifierImpl,
          () => organizationNotifierImpl.deleteOrganization(tId),
          [
            NotifierAssertParams(
              value: (notifier) => notifier.isLoading,
              matcher: true,
            ),
            NotifierAssertParams(
              value: (notifier) => notifier.isLoading,
              matcher: false,
            ),
            NotifierAssertParams(
              value: (notifier) => notifier.organization,
              matcher: null,
            ),
          ],
        );
        verify(mockDeleteOrganization(DeleteOrganizationParams(tId)));
        verifyNoMoreInteractions(mockDeleteOrganization);
      },
    );

    test(
      'should throw [Failure] if useCase fails',
      () async {
        when(mockDeleteOrganization(any))
            .thenAnswer((_) async => Left(tFailure));

        final call = organizationNotifierImpl.deleteOrganization;

        expect(
          () => call(tId),
          throwsA(isInstanceOf<ServerFailure>()),
        );

        verify(mockDeleteOrganization(DeleteOrganizationParams(tId)));
        verifyNoMoreInteractions(mockDeleteOrganization);
      },
    );
  });

  group('updateMember', () {
    test(
      'should set [Organization] and notify all listeners if useCase succeed',
      () async {
        when(mockUpdateMember(any))
            .thenAnswer((_) async => Right(tOrganization));

        await expectToNotifiyListener<OrganizationNotifierImpl>(
          organizationNotifierImpl,
          () => organizationNotifierImpl.updateMember(
            id: tId,
            userId: tUserId,
            role: OrganizationRoleType.member,
            status: OrganizationMemberStatus.active,
          ),
          [
            NotifierAssertParams(
              value: (notifier) => notifier.isLoading,
              matcher: true,
            ),
            NotifierAssertParams(
              value: (notifier) => notifier.isLoading,
              matcher: false,
            ),
            NotifierAssertParams(
              value: (notifier) => notifier.organization,
              matcher: tOrganization,
            ),
          ],
        );
        verify(mockUpdateMember(UpdateMemberParams(
          id: tId,
          userId: tUserId,
          role: OrganizationRoleType.member,
          status: OrganizationMemberStatus.active,
        )));
        verifyNoMoreInteractions(mockUpdateMember);
      },
    );

    test(
      'should throw [Failure] if useCase fails',
      () async {
        when(mockUpdateMember(any)).thenAnswer((_) async => Left(tFailure));

        final call = organizationNotifierImpl.updateMember;

        expect(
          () => call(
            id: tId,
            userId: tUserId,
            role: OrganizationRoleType.member,
            status: OrganizationMemberStatus.active,
          ),
          throwsA(isInstanceOf<ServerFailure>()),
        );

        verify(mockUpdateMember(UpdateMemberParams(
          id: tId,
          userId: tUserId,
          role: OrganizationRoleType.member,
          status: OrganizationMemberStatus.active,
        )));
        verifyNoMoreInteractions(mockUpdateMember);
      },
    );
  });

  group('removeMember', () {
    test(
      'should set [Organization] and notify all listeners if useCase succeed',
      () async {
        when(mockRemoveMember(any))
            .thenAnswer((_) async => Right(tOrganization));

        await expectToNotifiyListener<OrganizationNotifierImpl>(
          organizationNotifierImpl,
          () => organizationNotifierImpl.removeMember(
            id: tId,
            userId: tUserId,
          ),
          [
            NotifierAssertParams(
              value: (notifier) => notifier.isLoading,
              matcher: true,
            ),
            NotifierAssertParams(
              value: (notifier) => notifier.isLoading,
              matcher: false,
            ),
            NotifierAssertParams(
              value: (notifier) => notifier.organization,
              matcher: tOrganization,
            ),
          ],
        );
        verify(mockRemoveMember(RemoveMemberParams(
          id: tId,
          userId: tUserId,
        )));
        verifyNoMoreInteractions(mockRemoveMember);
      },
    );

    test(
      'should throw [Failure] if useCase fails',
      () async {
        when(mockRemoveMember(any)).thenAnswer((_) async => Left(tFailure));

        final call = organizationNotifierImpl.removeMember;

        expect(
          () => call(
            id: tId,
            userId: tUserId,
          ),
          throwsA(isInstanceOf<ServerFailure>()),
        );

        verify(mockRemoveMember(RemoveMemberParams(
          id: tId,
          userId: tUserId,
        )));
        verifyNoMoreInteractions(mockRemoveMember);
      },
    );
  });

  group('setOrganization', () {
    test(
      'should set [Organization] and notify all listeners if useCase succeed',
      () async {
        when(mockSaveOrganizationLocally(any)).thenAnswer(
          (_) async => Right(null),
        );

        await expectToNotifiyListener<OrganizationNotifierImpl>(
          organizationNotifierImpl,
          () => organizationNotifierImpl.setOrganization(
            id: tId,
            organization: tOrganization,
          ),
          [
            NotifierAssertParams(
              value: (notifier) => notifier.organization,
              matcher: tOrganization,
            ),
          ],
        );
        verify(mockSaveOrganizationLocally(SaveOrganizationLocallyParams(
          id: tId,
          organization: tOrganization,
        )));
        verifyNoMoreInteractions(mockRemoveMember);
      },
    );

    test(
      'should throw [Failure] if useCase fails',
      () async {
        when(mockSaveOrganizationLocally(any)).thenAnswer(
          (_) async => Left(tLocalFailure),
        );

        final call = organizationNotifierImpl.setOrganization;

        expect(
          () => call(
            id: tId,
            organization: tOrganization,
          ),
          throwsA(isInstanceOf<LocalFailure>()),
        );

        verify(mockSaveOrganizationLocally(SaveOrganizationLocallyParams(
          id: tId,
          organization: tOrganization,
        )));
        verifyNoMoreInteractions(mockRemoveMember);
      },
    );
  });
}
