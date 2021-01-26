import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseUser extends Mock implements User {}

class MockUserCredential extends Mock implements UserCredential {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

class MockCollectionReference extends Mock implements CollectionReference {}

class MockDocumentReference extends Mock implements DocumentReference {}

class MockFirebaseFacebookAuthProvider extends Mock
    implements FacebookAuthProvider {}

class MockFirebaseOAuthCredential extends Mock implements OAuthCredential {}

class MockGoogleAuthProvider extends Mock implements GoogleAuthProvider {}

class FirebaseMocks {
  final MockFirebaseAuth mockFirebaseAuth = MockFirebaseAuth();
  final MockFirebaseUser mockFirebaseUser = MockFirebaseUser();
  final MockUserCredential mockUserCredential = MockUserCredential();
  final MockFirebaseFirestore mockFirebaseFirestore = MockFirebaseFirestore();
  final MockDocumentSnapshot mockDocumentSnapshot = MockDocumentSnapshot();
  final MockCollectionReference mockCollectionReference =
      MockCollectionReference();
  final MockDocumentReference mockDocumentReference = MockDocumentReference();
  final MockFirebaseFacebookAuthProvider mockFirebaseFacebookAuthProvider =
      MockFirebaseFacebookAuthProvider();
  final MockFirebaseOAuthCredential mockFirebaseOAuthCredential =
      MockFirebaseOAuthCredential();
  final MockGoogleAuthProvider mockGoogleAuthProvider =
      MockGoogleAuthProvider();
}
