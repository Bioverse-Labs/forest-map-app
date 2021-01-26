import 'package:faker/faker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:forestMapApp/core/enums/social_login_types.dart';
import 'package:forestMapApp/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:forestMapApp/features/auth/data/models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../core/firebase/firebase_mocks.dart';

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

class MockGoogleSignInAuthentication extends Mock
    implements GoogleSignInAuthentication {}

class MockGoogleAuthCredential extends Mock implements GoogleAuthCredential {}

class MockFacebookAccessToken extends Mock implements AccessToken {}

void main() {
  AuthRemoteDataSourceImpl dataSource;
  MockGoogleSignIn mockGoogleSignIn;
  MockGoogleSignInAccount mockGoogleSignInAccount;
  MockGoogleSignInAuthentication mockGoogleSignInAuthentication;
  MockGoogleAuthCredential mockGoogleAuthCredential;
  MockFacebookAccessToken mockFacebookAccessToken;
  FirebaseMocks firebaseMocks;

  setUp(() {
    mockGoogleSignIn = MockGoogleSignIn();
    mockGoogleSignInAccount = MockGoogleSignInAccount();
    mockGoogleSignInAuthentication = MockGoogleSignInAuthentication();
    mockGoogleAuthCredential = MockGoogleAuthCredential();
    mockFacebookAccessToken = MockFacebookAccessToken();
    firebaseMocks = FirebaseMocks();
    dataSource = AuthRemoteDataSourceImpl(
      firebaseMocks.mockFirebaseAuth,
      firebaseMocks.mockFirebaseFirestore,
    );
  });

  final tUserId = faker.guid.guid();
  final tName = faker.person.name();
  final tEmail = faker.internet.email();
  final tPassword = faker.internet.password();
  final tAvatarUrl = faker.internet.uri('protocol');
  final tDocumentData = {
    'id': tUserId,
    'name': tName,
    'email': tEmail,
    'avatarUrl': tAvatarUrl,
  };
  final tUserModel = UserModel(
    id: tUserId,
    name: tName,
    email: tEmail,
    avatarUrl: tAvatarUrl,
  );

  group('signInWithEmailAndPassword', () {
    test('should return UserModel when signIn succeed', () async {
      when(firebaseMocks.mockUserCredential.user)
          .thenReturn(firebaseMocks.mockFirebaseUser);
      when(firebaseMocks.mockFirebaseUser.uid).thenReturn(tUserId);
      when(firebaseMocks.mockFirebaseFirestore.collection(any))
          .thenReturn(firebaseMocks.mockCollectionReference);
      when(firebaseMocks.mockCollectionReference.doc(any))
          .thenReturn(firebaseMocks.mockDocumentReference);
      when(firebaseMocks.mockDocumentReference.get())
          .thenAnswer((_) async => firebaseMocks.mockDocumentSnapshot);
      when(firebaseMocks.mockDocumentSnapshot.exists).thenReturn(true);
      when(firebaseMocks.mockDocumentSnapshot.data()).thenReturn(tDocumentData);
      when(
        firebaseMocks.mockFirebaseAuth.signInWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenAnswer((_) async => firebaseMocks.mockUserCredential);

      final result = await dataSource.signInWithEmailAndPassword(
        tEmail,
        tPassword,
      );

      verify(firebaseMocks.mockCollectionReference.doc(any));
      verify(
        firebaseMocks.mockFirebaseAuth.signInWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      );
      expect(result, equals(tUserModel));
      verifyNoMoreInteractions(firebaseMocks.mockFirebaseAuth);
    });
  });

  group('signInWithSocial', () {
    test('should return UserModel when Google signIn succeed', () async {
      when(firebaseMocks.mockUserCredential.user)
          .thenReturn(firebaseMocks.mockFirebaseUser);
      when(firebaseMocks.mockFirebaseUser.uid).thenReturn(tUserId);
      when(firebaseMocks.mockFirebaseFirestore.collection(any))
          .thenReturn(firebaseMocks.mockCollectionReference);
      when(firebaseMocks.mockCollectionReference.doc(any))
          .thenReturn(firebaseMocks.mockDocumentReference);
      when(firebaseMocks.mockDocumentReference.get())
          .thenAnswer((_) async => firebaseMocks.mockDocumentSnapshot);
      when(firebaseMocks.mockDocumentSnapshot.exists).thenReturn(true);
      when(firebaseMocks.mockDocumentSnapshot.data()).thenReturn(tDocumentData);
      when(firebaseMocks.mockFirebaseAuth.signInWithCredential(any))
          .thenAnswer((_) async => firebaseMocks.mockUserCredential);
      when(mockGoogleSignIn.signIn())
          .thenAnswer((_) async => mockGoogleSignInAccount);
      when(mockGoogleSignInAccount.authentication)
          .thenAnswer((_) async => mockGoogleSignInAuthentication);
      when(firebaseMocks.mockFirebaseAuth);

      final result = await dataSource.signInWithSocial(SocialLoginType.google);

      expect(result, tUserModel);
    });
  });
}
