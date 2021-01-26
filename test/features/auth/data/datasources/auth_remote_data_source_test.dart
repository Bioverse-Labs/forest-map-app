import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:forestMapApp/core/adapters/firebase_auth_adapter.dart';
import 'package:forestMapApp/core/adapters/firestore_adapter.dart';
import 'package:forestMapApp/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:forestMapApp/features/auth/data/models/user_model.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockFirestoreAdapterImpl extends Mock implements FirestoreAdapterImpl {}

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

class MockFirebaseAuthAdapterImpl extends Mock
    implements FirebaseAuthAdapterImpl {}

void main() {
  MockFirestoreAdapterImpl mockFirestoreAdapterImpl;
  MockFirebaseAuthAdapterImpl mockFirebaseAuthAdapterImpl;
  MockDocumentSnapshot mockDocumentSnapshot;
  AuthRemoteDataSourceImpl authRemoteDataSourceImpl;

  setUp(() {
    mockFirestoreAdapterImpl = MockFirestoreAdapterImpl();
    mockFirebaseAuthAdapterImpl = MockFirebaseAuthAdapterImpl();
    mockDocumentSnapshot = MockDocumentSnapshot();
    authRemoteDataSourceImpl = AuthRemoteDataSourceImpl(
      mockFirestoreAdapterImpl,
      mockFirebaseAuthAdapterImpl,
    );
  });

  final tUserId = faker.guid.guid();
  final tName = faker.person.name();
  final tEmail = faker.internet.email();
  final tAvatarUrl = faker.internet.uri('protocol');
  final tPassword = faker.internet.password();
  final tUserModel = UserModel(
    id: tUserId,
    name: tName,
    email: tEmail,
    avatarUrl: tAvatarUrl,
  );
  final tUserData = {
    'id': tUserId,
    'name': tName,
    'email': tEmail,
    'avatarUrl': tAvatarUrl,
  };

  group('signInWithEmailAndPassword', () {
    setUp(() {
      when(mockDocumentSnapshot.data()).thenReturn(tUserData);
    });

    test(
      ''' should return UserModal when signIn is succeed and document
      from firestore is successfuly retrieved
      ''',
      () async {
        when(mockFirebaseAuthAdapterImpl.signInWithEmailAndPassword(any, any))
            .thenAnswer((_) async => tUserModel);
        when(mockDocumentSnapshot.exists).thenReturn(true);
        when(mockFirestoreAdapterImpl.getDocument(any))
            .thenAnswer((_) async => mockDocumentSnapshot);

        final result = await authRemoteDataSourceImpl
            .signInWithEmailAndPassword(tEmail, tPassword);

        verify(mockFirebaseAuthAdapterImpl.signInWithEmailAndPassword(
          tEmail,
          tPassword,
        ));
        verify(mockFirestoreAdapterImpl.getDocument('users/$tUserId'));
        expect(result, tUserModel);
        verifyNoMoreInteractions(mockFirebaseAuthAdapterImpl);
        verifyNoMoreInteractions(mockFirestoreAdapterImpl);
      },
    );
  });
}
