import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forest_map/core/adapters/firebase_storage_adapter.dart';
import 'package:forest_map/core/adapters/firestore_adapter.dart';
import 'package:forest_map/core/enums/organization_member_status.dart';
import 'package:forest_map/core/enums/organization_role_types.dart';
import 'package:forest_map/core/errors/exceptions.dart';
import 'package:forest_map/core/util/localized_string.dart';
import 'package:forest_map/core/util/uuid_generator.dart';
import 'package:forest_map/features/user/data/models/user_model.dart';
import 'package:forest_map/features/organization/data/datasources/organization_remote_data_source.dart';
import 'package:forest_map/features/organization/data/models/member_model.dart';
import 'package:forest_map/features/organization/data/models/organization_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../core/adapters/firebase_storage_adapter_test.mocks.dart';
import 'organization_remote_data_source_test.mocks.dart';

@GenerateMocks([
  FirestoreAdapterImpl,
  FirebaseStorageAdapterImpl,
  LocalizedString,
  UUIDGenerator,
  DocumentReference,
  DocumentSnapshot,
  CollectionReference,
  FirebaseFirestore,
], customMocks: [
  MockSpec<QueryDocumentSnapshot<Map<String, dynamic>>>(
    as: #MockQueryDocumentSnapshot,
  ),
])
void main() {
  late MockFirestoreAdapterImpl mockFirestoreAdapter;
  late MockFirebaseStorageAdapterImpl mockFirebaseStorageAdapter;
  late MockLocalizedString mockLocalizedString;
  late MockUUIDGenerator mockUUIDGenerator;
  late MockDocumentReference mockDocumentReference;
  late MockDocumentSnapshot mockDocumentSnapshot;
  late MockQueryDocumentSnapshot mockQueryDocumentSnapshot;
  late MockCollectionReference<Map<String, dynamic>> mockCollectionReference;
  late MockFirebaseFirestore mockFirebaseFirestore;
  late OrganizationRemoteDataSourceImpl organizationDataSourceImpl;

  final tId = faker.guid.guid();
  final tName = faker.company.name();
  final tEmail = faker.internet.email();
  final tPhone = faker.randomGenerator.integer(9).toString();
  final tAvatarUrl = faker.image.image();
  final tAvatarFile = File(tAvatarUrl);

  final tUserId = faker.guid.guid();
  final tUserName = faker.person.name();
  final tUserModel = UserModel(id: tUserId, name: tUserName);
  final tMemberModel = MemberModel(
    id: tUserModel.id,
    name: tUserModel.name,
    role: OrganizationRoleType.owner,
    status: OrganizationMemberStatus.active,
  );
  final tOrganizationModel = OrganizationModel(
    id: tId,
    name: tName,
    email: tEmail,
    phone: tPhone,
    avatarUrl: tAvatarUrl,
    members: [tMemberModel],
  );

  setUp(() {
    mockFirestoreAdapter = MockFirestoreAdapterImpl();
    mockFirebaseStorageAdapter = MockFirebaseStorageAdapterImpl();
    mockLocalizedString = MockLocalizedString();
    mockUUIDGenerator = MockUUIDGenerator();
    mockDocumentReference = MockDocumentReference();
    mockDocumentSnapshot = MockDocumentSnapshot();
    mockQueryDocumentSnapshot = MockQueryDocumentSnapshot();
    mockCollectionReference = MockCollectionReference();
    mockFirebaseFirestore = MockFirebaseFirestore();
    organizationDataSourceImpl = OrganizationRemoteDataSourceImpl(
      firestoreAdapter: mockFirestoreAdapter,
      firebaseStorageAdapter: mockFirebaseStorageAdapter,
      localizedString: mockLocalizedString,
      uuidGenerator: mockUUIDGenerator,
    );

    when(mockFirebaseStorageAdapter.uploadFile(
      file: anyNamed('file'),
      storagePath: anyNamed('storagePath'),
    )).thenAnswer((_) => MockUploadTask());

    when(mockUUIDGenerator.generateUID()).thenReturn(tId);

    when(mockLocalizedString.getLocalizedString(any))
        .thenReturn(faker.lorem.word());

    when(mockFirestoreAdapter.updateDocument(any, any))
        .thenAnswer((_) async => mockDocumentReference);
  });

  group('createOrganization', () {
    test(
      'should return [OrganizationModel] with [Owner] member',
      () async {
        when(mockFirestoreAdapter.addDocument(any, any)).thenAnswer(
          (_) async => mockDocumentReference,
        );
        when(mockFirebaseStorageAdapter.getDownloadUrl(any)).thenAnswer(
          (_) async => tAvatarUrl,
        );

        final result = await organizationDataSourceImpl.createOrganization(
          name: tName,
          email: tEmail,
          phone: tPhone,
          avatar: tAvatarFile,
          user: tUserModel,
        );

        expect(result, tOrganizationModel);
        verify(mockFirestoreAdapter.addDocument(
          'organizations/$tId',
          {
            'id': tId,
            'name': tName,
            'email': tEmail,
            'phone': tPhone,
            'avatarUrl': tAvatarUrl,
          },
        ));
        verify(mockFirestoreAdapter.addDocument(
          'organizations/$tId/members/$tUserId',
          {
            'id': tUserId,
            'status': OrganizationMemberStatus.active.index,
            'role': OrganizationRoleType.owner.index,
          },
        ));
        verify(mockFirestoreAdapter.updateDocument(
          'users/$tUserId',
          {
            'organizations': [tOrganizationModel.id],
          },
        ));
        verify(mockFirebaseStorageAdapter.uploadFile(
          file: tAvatarFile,
          storagePath: 'organizations/$tId/avatar/avatar.png',
        ));
        verify(mockFirebaseStorageAdapter.getDownloadUrl(
          'organizations/$tId/avatar/avatar.png',
        ));
        verifyNoMoreInteractions(mockFirestoreAdapter);
        verifyNoMoreInteractions(mockFirebaseStorageAdapter);
      },
    );

    test(
      'should throw [ServerException] if firestore fails',
      () async {
        when(mockFirestoreAdapter.addDocument(any, any)).thenThrow(
          FirebaseException(
            plugin: 'firestore',
            message: faker.randomGenerator.string(20),
          ),
        );

        final call = organizationDataSourceImpl.createOrganization;

        expect(
          call(
            name: tName,
            email: tEmail,
            phone: tPhone,
            user: tUserModel,
          ),
          throwsA(isInstanceOf<ServerException>()),
        );
      },
    );
  });

  group('getOrganization', () {
    final orgDocSnapshot = MockDocumentSnapshot();
    final userDocSnapshot = MockDocumentSnapshot();
    test(
      'should return [OrganizationModel] if document exists',
      () async {
        when(mockFirestoreAdapter.getDocument('organizations/$tId'))
            .thenAnswer((_) async => orgDocSnapshot);
        when(mockFirestoreAdapter.firestore).thenReturn(mockFirebaseFirestore);
        when(mockFirebaseFirestore.collection(any))
            .thenReturn(mockCollectionReference);
        when(orgDocSnapshot.exists).thenReturn(true);
        when(orgDocSnapshot.data()).thenReturn({
          'id': tId,
          'name': tName,
          'email': tEmail,
          'phone': tPhone,
          'avatarUrl': tAvatarUrl,
        });
        when(mockFirestoreAdapter.runQuery(any))
            .thenAnswer((_) async => [mockQueryDocumentSnapshot]);
        when(mockQueryDocumentSnapshot.data()).thenReturn({
          'id': tUserModel.id,
          'name': tUserModel.name,
          'status': OrganizationMemberStatus.active.index,
          'role': OrganizationRoleType.owner.index,
        });
        when(mockQueryDocumentSnapshot.id).thenReturn(tUserId);
        when(mockFirestoreAdapter.getDocument('users/$tUserId'))
            .thenAnswer((_) async => userDocSnapshot);
        when(userDocSnapshot.exists).thenReturn(true);
        when(userDocSnapshot.data()).thenReturn(<String, dynamic>{});

        final result = await organizationDataSourceImpl.getOrganization(tId);

        expect(result, tOrganizationModel);
        verify(mockFirestoreAdapter.getDocument('organizations/$tId'));
        verify(mockFirebaseFirestore.collection('organizations/$tId/members'));
        verify(mockFirestoreAdapter.runQuery(mockCollectionReference));
      },
    );

    test(
      'should throw [ServerException] if firestore fails',
      () async {
        when(mockFirestoreAdapter.getDocument(any)).thenThrow(
          FirebaseException(
            plugin: 'firestore',
            message: faker.randomGenerator.string(20),
          ),
        );

        final call = organizationDataSourceImpl.getOrganization;

        expect(
          () => call(tId),
          throwsA(isInstanceOf<ServerException>()),
        );
      },
    );
  });

  group('updateOrganization', () {
    final orgDocSnapshot = MockDocumentSnapshot();
    final userDocSnapshot = MockDocumentSnapshot();
    test(
      'should return [OrganizationModel] with updated data',
      () async {
        when(mockDocumentReference.get())
            .thenAnswer((_) async => orgDocSnapshot);
        when(orgDocSnapshot.data()).thenReturn({
          'id': tId,
          'name': tName,
          'email': tEmail,
          'phone': tPhone,
          'avatarUrl': tAvatarUrl,
        });
        when(mockFirebaseStorageAdapter.getDownloadUrl(any)).thenAnswer(
          (_) async => tAvatarUrl,
        );
        when(mockFirestoreAdapter.firestore).thenReturn(mockFirebaseFirestore);
        when(mockFirebaseFirestore.collection(any))
            .thenReturn(mockCollectionReference);
        when(mockFirestoreAdapter.runQuery(any))
            .thenAnswer((_) async => [mockQueryDocumentSnapshot]);
        when(mockQueryDocumentSnapshot.id).thenReturn(tUserId);
        when(mockQueryDocumentSnapshot.data()).thenReturn({
          'id': tUserModel.id,
          'name': tUserModel.name,
          'status': OrganizationMemberStatus.active.index,
          'role': OrganizationRoleType.owner.index,
        });
        when(mockFirestoreAdapter.getDocument('organizations/$tId'))
            .thenAnswer((_) async => orgDocSnapshot);
        when(orgDocSnapshot.exists).thenReturn(true);
        when(mockFirestoreAdapter.getDocument('users/$tUserId'))
            .thenAnswer((_) async => userDocSnapshot);
        when(userDocSnapshot.exists).thenReturn(true);
        when(userDocSnapshot.data()).thenReturn(<String, dynamic>{});

        final result = await organizationDataSourceImpl.updateOrganization(
          id: tId,
          name: tName,
          email: tEmail,
          phone: tPhone,
          avatar: tAvatarFile,
        );

        expect(result, tOrganizationModel);
        verify(mockFirestoreAdapter.updateDocument(
          'organizations/$tId',
          {
            'id': tId,
            'name': tName,
            'email': tEmail,
            'phone': tPhone,
            'avatarUrl': tAvatarUrl,
          },
        ));
        verify(mockFirebaseStorageAdapter.uploadFile(
          file: tAvatarFile,
          storagePath: 'organizations/$tId/avatar/avatar.png',
        ));
        verify(mockFirebaseStorageAdapter.getDownloadUrl(
          'organizations/$tId/avatar/avatar.png',
        ));
        verify(mockFirebaseFirestore.collection('organizations/$tId/members'));
        verify(mockFirestoreAdapter.runQuery(mockCollectionReference));
        verifyNoMoreInteractions(mockFirebaseStorageAdapter);
      },
    );

    test(
      'should throw [ServerException] if firestore fails',
      () async {
        when(mockFirestoreAdapter.updateDocument(any, any)).thenThrow(
          FirebaseException(
            plugin: 'firestore',
            message: faker.randomGenerator.string(20),
          ),
        );

        final call = organizationDataSourceImpl.updateOrganization;

        expect(
          () => call(
            name: tName,
            email: tEmail,
            phone: tPhone,
          ),
          throwsA(isInstanceOf<ServerException>()),
        );
      },
    );
  });

  group('deleteOrganization', () {
    test(
      'should delete [Organization] from firestore',
      () async {
        // when(mockFirestoreAdapter.deleteDocument(any)).thenAnswer((_) => null);

        await organizationDataSourceImpl.deleteOrganization(tId);

        verify(mockFirestoreAdapter.deleteDocument('organizations/$tId'));
        verifyNoMoreInteractions(mockFirestoreAdapter);
      },
    );

    test(
      'should throw [ServerException] if firestore fails',
      () async {
        when(mockFirestoreAdapter.deleteDocument(any)).thenThrow(
          FirebaseException(
            plugin: 'firestore',
            message: faker.randomGenerator.string(20),
          ),
        );

        final call = organizationDataSourceImpl.deleteOrganization;

        expect(
          () => call(tId),
          throwsA(isInstanceOf<ServerException>()),
        );
      },
    );
  });

  group('removeMember', () {
    final tRemoveMemberOrganizationOrUserMap = {
      'id': tId,
      'name': tName,
      'email': tEmail,
      'phone': tPhone,
      'avatarUrl': tAvatarUrl,
      'members': const <MemberModel>[],
      'organizations': [tId],
    };
    final tRemoveMemberExpectedOrgModel =
        OrganizationModel.fromMap(tRemoveMemberOrganizationOrUserMap);
    test(
      'should remove [Member] from organization',
      () async {
        when(mockFirestoreAdapter.getDocument(any))
            .thenAnswer((_) async => mockDocumentSnapshot);
        when(mockDocumentSnapshot.exists).thenReturn(true);
        when(mockDocumentSnapshot.data())
            .thenReturn(tRemoveMemberOrganizationOrUserMap);
        when(mockFirestoreAdapter.firestore).thenReturn(mockFirebaseFirestore);
        when(mockFirebaseFirestore.collection(any))
            .thenReturn(mockCollectionReference);
        when(mockFirestoreAdapter.runQuery(any)).thenAnswer((_) async => []);

        final result = await organizationDataSourceImpl.removeMember(
          id: tId,
          userId: tUserId,
        );
        expect(
          result,
          tRemoveMemberExpectedOrgModel,
        );
        verify(
          mockFirestoreAdapter
              .deleteDocument('organizations/$tId/members/$tUserId'),
        );
        verify(mockFirestoreAdapter.getDocument('users/$tUserId'));
        verify(mockFirestoreAdapter.updateDocument('users/$tUserId', {
          'organizations': [],
        }));
        verify(mockFirestoreAdapter.getDocument('organizations/$tId'));
      },
    );

    test(
      'should throw [ServerException] if firestore fails',
      () async {
        when(mockFirestoreAdapter.deleteDocument(any)).thenThrow(
          FirebaseException(
            plugin: 'firestore',
            message: faker.randomGenerator.string(20),
          ),
        );

        final call = organizationDataSourceImpl.removeMember;

        expect(
          () => call(id: tId, userId: tUserId),
          throwsA(isInstanceOf<ServerException>()),
        );
      },
    );
  });

  group('updateMember', () {
    final tRemoveMemberOrganizationOrUserMap = {
      'id': tId,
      'name': tName,
      'email': tEmail,
      'phone': tPhone,
      'avatarUrl': tAvatarUrl,
      'members': <MemberModel>[
        MemberModel.fromMap({
          'id': tUserId,
          'name': tName,
          'email': tEmail,
          'phone': tPhone,
          'avatarUrl': tAvatarUrl,
          'status': OrganizationMemberStatus.active.index,
          'role': OrganizationRoleType.member.index,
        })
      ],
      'organizations': [tId],
    };
    final tRemoveMemberExpectedOrgModel =
        OrganizationModel.fromMap(tRemoveMemberOrganizationOrUserMap);
    test(
      'should return [OrganizationModel] with modified member',
      () async {
        when(mockFirestoreAdapter.getDocument(any))
            .thenAnswer((_) async => mockDocumentSnapshot);
        when(mockDocumentSnapshot.exists).thenReturn(true);
        when(mockDocumentSnapshot.data())
            .thenReturn(tRemoveMemberOrganizationOrUserMap);
        when(mockFirestoreAdapter.firestore).thenReturn(mockFirebaseFirestore);
        when(mockFirebaseFirestore.collection(any))
            .thenReturn(mockCollectionReference);
        when(mockFirestoreAdapter.runQuery(any))
            .thenAnswer((_) async => [mockQueryDocumentSnapshot]);
        when(mockQueryDocumentSnapshot.id).thenReturn(tUserId);
        when(mockQueryDocumentSnapshot.data()).thenReturn({
          'id': tUserId,
          'status': OrganizationMemberStatus.active.index,
          'role': OrganizationRoleType.member.index,
        });

        final result = await organizationDataSourceImpl.updateMember(
          id: tId,
          userId: tUserId,
          role: OrganizationRoleType.member,
        );
        expect(
          result,
          tRemoveMemberExpectedOrgModel,
        );
        verify(
          mockFirestoreAdapter.updateDocument(
            'organizations/$tId/members/$tUserId',
            {
              'role': OrganizationRoleType.member.index,
            },
          ),
        );
        verify(mockFirestoreAdapter.getDocument('users/$tUserId'));
        verify(mockFirestoreAdapter.getDocument('organizations/$tId'));
      },
    );

    test(
      'should throw [ServerException] if firestore fails',
      () async {
        when(mockFirestoreAdapter.deleteDocument(any)).thenThrow(
          FirebaseException(
            plugin: 'firestore',
            message: faker.randomGenerator.string(20),
          ),
        );

        final call = organizationDataSourceImpl.removeMember;

        expect(
          () => call(id: tId, userId: tUserId),
          throwsA(isInstanceOf<ServerException>()),
        );
      },
    );
  });
}
