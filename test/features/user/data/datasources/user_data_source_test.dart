import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forestMapApp/core/adapters/firebase_storage_adapter.dart';
import 'package:forestMapApp/core/adapters/firestore_adapter.dart';
import 'package:forestMapApp/core/enums/organization_member_status.dart';
import 'package:forestMapApp/core/enums/organization_role_types.dart';
import 'package:forestMapApp/core/errors/exceptions.dart';
import 'package:forestMapApp/core/util/localized_string.dart';
import 'package:forestMapApp/features/user/data/datasource/user_data_source.dart';
import 'package:mockito/mockito.dart';

class MockFirestoreAdapter extends Mock implements FirestoreAdapterImpl {}

class MockFirebaseStorageAdapter extends Mock
    implements FirebaseStorageAdapterImpl {}

class MockLocalizedString extends Mock implements LocalizedString {}

class MockFirestore extends Mock implements FirebaseFirestore {}

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot {}

class MockCollectionReference extends Mock implements CollectionReference {}

void main() {
  MockFirestoreAdapter mockFirestoreAdapter;
  MockFirebaseStorageAdapter mockFirebaseStorageAdapter;
  MockLocalizedString mockLocalizedString;
  MockFirestore mockFirestore;
  UserDataSourceImpl userDataSourceImpl;

  setUp(() {
    mockFirestoreAdapter = MockFirestoreAdapter();
    mockFirebaseStorageAdapter = MockFirebaseStorageAdapter();
    mockFirestore = MockFirestore();
    mockLocalizedString = MockLocalizedString();
    userDataSourceImpl = UserDataSourceImpl(
      firestoreAdapter: mockFirestoreAdapter,
      firebaseStorageAdapter: mockFirebaseStorageAdapter,
      localizedString: mockLocalizedString,
    );
  });

  final tId = faker.guid.guid();
  final tName = faker.person.name();
  final tEmail = faker.internet.email();
  final tAvatarUrl = faker.image.image();
  final tOrgId = faker.guid.guid();
  final tOrgName = faker.company.name();
  final tOrgEmail = faker.internet.email();
  final tOrgPhone = faker.randomGenerator.integer(9, min: 9).toString();

  final tUserDocSnapshot = MockDocumentSnapshot();
  final tOrgDocSnapshot = MockDocumentSnapshot();
  final tQuerySnapshot = MockQueryDocumentSnapshot();
  final tCollectionReference = MockCollectionReference();

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

        await userDataSourceImpl.getUser(tId);
        verifyInOrder([
          mockFirestoreAdapter.getDocument('users/$tId'),
          mockFirestoreAdapter.getDocument('organizations/$tOrgId'),
          mockFirestoreAdapter.firestore,
          mockFirestoreAdapter.runQuery(tCollectionReference),
          mockFirestoreAdapter.getDocument('users/$tId'),
        ]);
        verifyNoMoreInteractions(mockFirestoreAdapter);
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

        await userDataSourceImpl.updateUser(id: tId, email: tEmail);
        verifyInOrder([
          mockFirestoreAdapter.updateDocument(
            'users/$tId',
            {'email': tEmail},
          ),
          mockFirestoreAdapter.getDocument('users/$tId'),
          mockFirestoreAdapter.getDocument('organizations/$tOrgId'),
          mockFirestoreAdapter.firestore,
          mockFirestoreAdapter.runQuery(tCollectionReference),
          mockFirestoreAdapter.getDocument('users/$tId'),
        ]);
        verifyNoMoreInteractions(mockFirestoreAdapter);
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
        when(mockFirestoreAdapter.updateDocument(any, any)).thenThrow(
          FirebaseException(
            plugin: 'firestore',
            message: faker.randomGenerator.string(20),
          ),
        );
        when(tUserDocSnapshot.exists).thenReturn(false);

        final call = userDataSourceImpl.updateUser;

        expect(
          () => call(id: tId, email: tEmail),
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
