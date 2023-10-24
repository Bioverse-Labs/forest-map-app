import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forest_map/core/adapters/firebase_storage_adapter.dart';
import 'package:forest_map/core/adapters/firestore_adapter_impl.dart';
import 'package:forest_map/core/enums/organization_member_status.dart';
import 'package:forest_map/core/enums/organization_role_types.dart';
import 'package:forest_map/core/errors/exceptions.dart';
import 'package:forest_map/core/util/localized_string.dart';
import 'package:forest_map/features/organization/data/datasources/organization_remote_data_source.dart';
import 'package:forest_map/features/organization/data/models/organization_model.dart';
import 'package:forest_map/features/organization/domain/entities/organization.dart';
import 'package:forest_map/features/user/data/datasource/user_remote_data_source.dart';
import 'package:forest_map/features/user/data/models/user_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'user_remote_data_source_test.mocks.dart';

@GenerateMocks([
  FirestoreAdapterImpl,
  FirebaseStorageAdapterImpl,
  LocalizedString,
  FirebaseFirestore,
  DocumentSnapshot,
  UploadTask,
  OrganizationRemoteDataSource,
  CollectionReference,
  DocumentReference,
], customMocks: [
  MockSpec<QueryDocumentSnapshot<Map<String, dynamic>>>(
    as: #MockQueryDocumentSnapshot,
  ),
])
void main() {
  late MockFirestoreAdapterImpl mockFirestoreAdapter;
  late MockFirebaseStorageAdapterImpl mockFirebaseStorageAdapter;
  late MockLocalizedString mockLocalizedString;
  late MockFirebaseFirestore mockFirestore;
  late MockOrganizationRemoteDataSource mockOrganizationDataSource;
  late UserRemoteDataSourceImpl userDataSourceImpl;

  final tId = faker.guid.guid();
  final tName = faker.person.name();
  final tEmail = faker.internet.email();
  final tAvatarUrl = faker.image.image();
  final tOrgId = faker.guid.guid();
  final tOrgName = faker.company.name();
  final tOrgEmail = faker.internet.email();
  final tOrgPhone = faker.randomGenerator.integer(9, min: 9).toString();
  final tOrganization = Organization(
    id: tOrgId,
    name: tOrgName,
    email: tOrgEmail,
    phone: tOrgPhone,
    avatarUrl: tAvatarUrl,
  );

  final tUserDocSnapshot = MockDocumentSnapshot();
  final tOrgDocSnapshot = MockDocumentSnapshot();
  final tQuerySnapshot = MockQueryDocumentSnapshot();
  final tDocumentReference = MockDocumentReference();
  final tCollectionReference = MockCollectionReference<Map<String, dynamic>>();

  setUp(() {
    mockFirestoreAdapter = MockFirestoreAdapterImpl();
    mockFirebaseStorageAdapter = MockFirebaseStorageAdapterImpl();
    mockFirestore = MockFirebaseFirestore();
    mockLocalizedString = MockLocalizedString();
    mockOrganizationDataSource = MockOrganizationRemoteDataSource();
    userDataSourceImpl = UserRemoteDataSourceImpl(
      firestoreAdapter: mockFirestoreAdapter,
      firebaseStorageAdapter: mockFirebaseStorageAdapter,
      localizedString: mockLocalizedString,
      organizationRemoteDataSource: mockOrganizationDataSource,
    );

    when(mockLocalizedString.getLocalizedString(any))
        .thenReturn(faker.randomGenerator.string(20));
    when(mockOrganizationDataSource.getOrganization(any)).thenAnswer(
      (_) async => OrganizationModel.fromEntity(tOrganization),
    );
    when(mockFirestoreAdapter.updateDocument(any, any)).thenAnswer(
      (_) async => tDocumentReference,
    );
  });

  group('getUser', () {
    test(
      'should return [UserModel] if adapter succeed',
      () async {
        when(mockFirestoreAdapter.getDocument('users/$tId'))
            .thenAnswer((_) async => tUserDocSnapshot);
        when(mockFirestoreAdapter.getDocument('organizations/$tOrgId'))
            .thenAnswer((_) async => tOrgDocSnapshot);
        when(tUserDocSnapshot.exists).thenReturn(true);
        when(tUserDocSnapshot.data()).thenReturn({
          'id': tId,
          'name': tName,
          'email': tEmail,
          'avatarUrl': tAvatarUrl,
          'organizations': [tOrgId],
        });
        when(tOrgDocSnapshot.exists).thenReturn(true);
        when(tOrgDocSnapshot.data()).thenReturn({
          'id': tOrgId,
          'name': tOrgName,
          'email': tOrgEmail,
          'avatarUrl': tAvatarUrl,
          'phone': tOrgPhone,
        });
        when(mockFirestoreAdapter.firestore).thenReturn(mockFirestore);
        when(mockFirestore.collection(any)).thenReturn(tCollectionReference);
        when(mockFirestoreAdapter.runQuery(any))
            .thenAnswer((_) async => [tQuerySnapshot]);
        when(tQuerySnapshot.exists).thenReturn(true);
        when(tQuerySnapshot.id).thenReturn(tId);
        when(tQuerySnapshot.data()).thenReturn({
          'id': tId,
          'name': tName,
          'role': OrganizationRoleType.owner.index,
          'status': OrganizationMemberStatus.active.index,
        });

        final result = await userDataSourceImpl.getUser(tId);

        expect(result, isA<UserModel>());
      },
    );

    test(
      'should throw [ServerException] if document does not exists',
      () async {
        when(mockFirestoreAdapter.getDocument('users/$tId'))
            .thenAnswer((_) async => tUserDocSnapshot);
        when(tUserDocSnapshot.exists).thenReturn(false);

        final call = userDataSourceImpl.getUser;

        expect(() => call(tId), throwsA(isInstanceOf<ServerException>()));
        verify(mockFirestoreAdapter.getDocument('users/$tId'));
        verifyNoMoreInteractions(mockFirestoreAdapter);
      },
    );

    test(
      'should throw [ServerException] if an [FirebaseException] is thrown',
      () async {
        when(mockFirestoreAdapter.getDocument('users/$tId')).thenThrow(
          FirebaseException(
            plugin: 'firestore',
            message: faker.randomGenerator.string(20),
          ),
        );
        when(tUserDocSnapshot.exists).thenReturn(false);

        final call = userDataSourceImpl.getUser;

        expect(() => call(tId), throwsA(isInstanceOf<ServerException>()));
        verify(mockFirestoreAdapter.getDocument('users/$tId'));
        verifyNoMoreInteractions(mockFirestoreAdapter);
      },
    );
  });

  group('updateUser', () {
    test(
      'should return [UserModel] if adapter succeed',
      () async {
        when(mockFirestoreAdapter.getDocument('users/$tId'))
            .thenAnswer((_) async => tUserDocSnapshot);
        when(tUserDocSnapshot.exists).thenReturn(true);
        when(tUserDocSnapshot.data()).thenReturn({
          'id': tId,
          'name': tName,
        });
        when(mockFirestoreAdapter.getDocument('organizations/$tOrgId'))
            .thenAnswer((_) async => tOrgDocSnapshot);
        when(tUserDocSnapshot.exists).thenReturn(true);
        when(tUserDocSnapshot.data()).thenReturn({
          'id': tId,
          'name': tName,
          'email': tEmail,
          'avatarUrl': tAvatarUrl,
          'organizations': [tOrgId],
        });
        when(tOrgDocSnapshot.exists).thenReturn(true);
        when(tOrgDocSnapshot.data()).thenReturn({
          'id': tOrgId,
          'name': tOrgName,
          'email': tOrgEmail,
          'avatarUrl': tAvatarUrl,
          'phone': tOrgPhone,
        });
        when(mockFirestoreAdapter.firestore).thenReturn(mockFirestore);
        when(mockFirestore.collection(any)).thenReturn(tCollectionReference);
        when(mockFirestoreAdapter.runQuery(any))
            .thenAnswer((_) async => [tQuerySnapshot]);
        when(tQuerySnapshot.exists).thenReturn(true);
        when(tQuerySnapshot.id).thenReturn(tId);
        when(tQuerySnapshot.data()).thenReturn({
          'id': tId,
          'name': tName,
          'role': OrganizationRoleType.owner.index,
          'status': OrganizationMemberStatus.active.index,
        });
        when(mockFirebaseStorageAdapter.uploadFile(
          file: anyNamed('file'),
          storagePath: anyNamed('storagePath'),
        )).thenAnswer((_) => MockUploadTask());
        when(mockFirebaseStorageAdapter.getDownloadUrl(any)).thenAnswer(
          (_) async => tAvatarUrl,
        );

        final result = await userDataSourceImpl.updateUser(
          id: tId,
          name: tName,
          email: tEmail,
          avatar: File(tAvatarUrl),
          organizations: [tOrganization],
        );

        expect(result, isA<UserModel>());
      },
    );

    test(
      'should throw [ServerException] if document does not exists',
      () async {
        when(mockFirestoreAdapter.getDocument(any))
            .thenAnswer((_) async => tUserDocSnapshot);
        when(tUserDocSnapshot.exists).thenReturn(false);

        final call = userDataSourceImpl.updateUser;

        expect(
          call(id: tId, name: tName),
          throwsA(isInstanceOf<ServerException>()),
        );
        verify(mockFirestoreAdapter.updateDocument(
          'users/$tId',
          {'name': tName},
        ));
        verifyNoMoreInteractions(mockFirestoreAdapter);
      },
    );

    test(
      'should throw [ServerException] if an [FirebaseException] is thrown',
      () async {
        when(mockFirestoreAdapter.updateDocument(any, any)).thenThrow(
          FirebaseException(
            plugin: 'firestore',
            message: faker.randomGenerator.string(20),
          ),
        );
        when(tUserDocSnapshot.exists).thenReturn(false);

        final call = userDataSourceImpl.updateUser;

        expect(
          call(id: tId, email: tEmail),
          throwsA(isInstanceOf<ServerException>()),
        );
        verify(mockFirestoreAdapter.updateDocument(
          'users/$tId',
          {'email': tEmail},
        ));
        verifyNoMoreInteractions(mockFirestoreAdapter);
      },
    );
  });
}
