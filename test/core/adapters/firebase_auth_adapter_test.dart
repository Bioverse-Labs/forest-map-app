import 'package:faker/faker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:forest_map_app/core/adapters/firebase_auth_adapter.dart';
import 'package:forest_map_app/features/user/data/models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockFacebookAuth extends Mock implements FacebookAuth {}

class MockUserCredential extends Mock implements UserCredential {}

class MockFirebaseUser extends Mock implements User {}

class MockAuthCredential extends Mock implements AuthCredential {}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

class MockGoogleSignInAuthentication extends Mock
    implements GoogleSignInAuthentication {}

class MockSocialCredentialAdapterImpl extends Mock
    implements SocialCredentialAdapterImpl {}

void main() {
  MockFirebaseAuth mockFirebaseAuth;
  MockGoogleSignIn mockGoogleSignIn;
  MockFacebookAuth mockFacebookAuth;
  MockUserCredential mockUserCredential;
  MockFirebaseUser mockFirebaseUser;
  MockSocialCredentialAdapterImpl mockSocialCredentialAdapterImpl;
  FirebaseAuthAdapterImpl firebaseAuthAdapterImpl;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockGoogleSignIn = MockGoogleSignIn();
    mockFacebookAuth = MockFacebookAuth();
    mockUserCredential = MockUserCredential();
    mockFirebaseUser = MockFirebaseUser();
    mockSocialCredentialAdapterImpl = MockSocialCredentialAdapterImpl();
    firebaseAuthAdapterImpl = FirebaseAuthAdapterImpl(
      mockFirebaseAuth,
      mockGoogleSignIn,
      mockFacebookAuth,
      mockSocialCredentialAdapterImpl,
    );
  });

  group('Firebase Auth Adapter', () {
    final tEmail = faker.internet.email();
    final tPassword = faker.internet.password();
    final tName = faker.person.name();
    final tAvatarUrl = faker.internet.uri('protocol');
    final tUserId = faker.guid.guid();
    final tAuthCredential = MockAuthCredential();
    final tUserModel = UserModel(
      id: tUserId,
      name: tName,
      email: tEmail,
      avatarUrl: tAvatarUrl,
    );

    setUp(() {
      when(mockUserCredential.user).thenReturn(mockFirebaseUser);
      when(mockFirebaseUser.uid).thenReturn(tUserId);
      when(mockFirebaseUser.displayName).thenReturn(tName);
      when(mockFirebaseUser.email).thenReturn(tEmail);
      when(mockFirebaseUser.photoURL).thenReturn(tAvatarUrl);
    });

    group('signInWithEmailAndPassword', () {
      test(
        'should return UserModel when signIn succeed',
        () async {
          when(
            mockFirebaseAuth.signInWithEmailAndPassword(
              email: anyNamed('email'),
              password: anyNamed('password'),
            ),
          ).thenAnswer((_) async => mockUserCredential);

          final result = await firebaseAuthAdapterImpl
              .signInWithEmailAndPassword(tEmail, tPassword);

          verify(mockFirebaseAuth.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ));
          expect(result, tUserModel);
          verifyNoMoreInteractions(mockFirebaseAuth);
        },
      );
    });

    group('signUpUserWithEmailAndPassword', () {
      test(
        'should return UserModel when user is succeed added to firebase',
        () async {
          when(mockFirebaseAuth.createUserWithEmailAndPassword(
            email: anyNamed('email'),
            password: anyNamed('password'),
          )).thenAnswer((_) async => mockUserCredential);

          final result = await firebaseAuthAdapterImpl
              .signUpUserWithEmailAndPassword(tEmail, tPassword);

          verify(mockFirebaseAuth.createUserWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ));
          expect(result, tUserModel);
          verifyNoMoreInteractions(mockFirebaseAuth);
        },
      );
    });

    group('signInWithCredential', () {
      test(
        'should return UserModel when credential signIn succeed',
        () async {
          when(mockFirebaseAuth.signInWithCredential(any))
              .thenAnswer((_) async => mockUserCredential);

          final result = await firebaseAuthAdapterImpl
              .signInWithCredential(tAuthCredential);

          verify(mockFirebaseAuth.signInWithCredential(tAuthCredential));
          expect(result, tUserModel);
          verifyNoMoreInteractions(mockFirebaseAuth);
        },
      );
    });

    group('getFacebookAuthCredential', () {
      final tAccessToken = AccessToken(
        token: faker.guid.guid(),
        isExpired: false,
        userId: faker.guid.guid(),
        applicationId: faker.guid.guid(),
        lastRefresh: DateTime.now(),
        grantedPermissions: [],
        expires: DateTime.now(),
        declinedPermissions: [],
      );

      final tResult =
          LoginResult(status: LoginStatus.success, accessToken: tAccessToken);

      test(
        'should return AuthCredential if Facebook login succeed',
        () async {
          when(mockFacebookAuth.login()).thenAnswer((_) async => tResult);
          when(mockSocialCredentialAdapterImpl.getFacebookCredential(any))
              .thenAnswer((_) async => tAuthCredential);

          final result =
              await firebaseAuthAdapterImpl.getFacebookAuthCredential();

          verify(mockSocialCredentialAdapterImpl
              .getFacebookCredential(tAccessToken.token));
          expect(result, tAuthCredential);
          verifyNoMoreInteractions(mockSocialCredentialAdapterImpl);
        },
      );
    });

    group('signOut', () {
      test(
        'should signOut',
        () async {
          when(mockFirebaseAuth.signOut()).thenAnswer((_) async => null);

          await firebaseAuthAdapterImpl.signOut();

          verify(mockFirebaseAuth.signOut());
        },
      );
    });

    group('getGoogleAuthCredential', () {
      MockGoogleSignInAccount mockGoogleSignInAccount;
      MockGoogleSignInAuthentication mockGoogleSignInAuthentication;
      final tAccessToken = faker.guid.guid();
      final tIdToken = faker.guid.guid();

      setUp(() {
        mockGoogleSignInAccount = MockGoogleSignInAccount();
        mockGoogleSignInAuthentication = MockGoogleSignInAuthentication();

        when(mockGoogleSignInAccount.authentication)
            .thenAnswer((_) async => mockGoogleSignInAuthentication);
        when(mockGoogleSignInAuthentication.accessToken)
            .thenReturn(tAccessToken);
        when(mockGoogleSignInAuthentication.idToken).thenReturn(tIdToken);
      });

      test(
        'should return AuthCredential if Google login succeed',
        () async {
          when(mockGoogleSignIn.signIn())
              .thenAnswer((_) async => mockGoogleSignInAccount);
          when(mockSocialCredentialAdapterImpl.getGoogleCredential(any, any))
              .thenAnswer((_) async => tAuthCredential);

          final result =
              await firebaseAuthAdapterImpl.getGoogleAuthCredential();

          verify(mockSocialCredentialAdapterImpl.getGoogleCredential(
            tAccessToken,
            tIdToken,
          ));
          expect(result, tAuthCredential);
          verifyNoMoreInteractions(mockSocialCredentialAdapterImpl);
        },
      );
    });
  });
}
