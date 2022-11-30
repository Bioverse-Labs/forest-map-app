import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:forest_map_app/core/enums/exception_origin_types.dart';
import 'package:forest_map_app/core/enums/social_login_types.dart';
import 'package:forest_map_app/core/errors/failure.dart';
import 'package:forest_map_app/features/auth/domain/usecases/forgot_password.dart';
import 'package:forest_map_app/features/auth/domain/usecases/sign_out.dart';
import 'package:forest_map_app/features/user/domain/entities/user.dart';
import 'package:forest_map_app/features/auth/domain/usecases/sign_in_with_email_and_password.dart';
import 'package:forest_map_app/features/auth/domain/usecases/sign_in_with_social.dart';
import 'package:forest_map_app/features/auth/domain/usecases/sign_up.dart';
import 'package:forest_map_app/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../core/notifiers/change_notifiers.dart';

class MockSignInWithEmailAndPassword extends Mock
    implements SignInWithEmailAndPassword {}

class MockSignInWithSocial extends Mock implements SignInWithSocial {}

class MockSignUp extends Mock implements SignUp {}

class MockSignOut extends Mock implements SignOut {}

class MockForgotPassword extends Mock implements ForgotPassword {}

void main() {
  MockSignInWithEmailAndPassword mockSignInWithEmailAndPassword;
  MockSignInWithSocial mockSignInWithSocial;
  MockSignUp mockSignUp;
  MockSignOut mockSignOut;
  MockForgotPassword mockForgotPassword;
  AuthNotifierImpl authNotifierImpl;

  setUp(() {
    mockSignInWithEmailAndPassword = MockSignInWithEmailAndPassword();
    mockSignInWithSocial = MockSignInWithSocial();
    mockSignUp = MockSignUp();
    mockForgotPassword = MockForgotPassword();

    authNotifierImpl = AuthNotifierImpl(
      mockSignInWithEmailAndPassword,
      mockSignInWithSocial,
      mockSignUp,
      mockSignOut,
      mockForgotPassword,
    );
  });

  final tEmail = faker.internet.email();
  final tPassword = faker.internet.password();
  final tName = faker.person.name();
  final tUser = User(id: faker.guid.guid(), name: tName, email: tEmail);
  final tFailure = ServerFailure(
    faker.randomGenerator.string(20),
    faker.randomGenerator.string(4),
    ExceptionOriginTypes.test,
  );

  group('signInWithEmailAndPassword', () {
    test(
      'should set [User _user] when usecase succeed',
      () async {
        when(mockSignInWithEmailAndPassword(any))
            .thenAnswer((_) async => Right(tUser));

        await expectToNotifiyListener<AuthNotifierImpl>(
          authNotifierImpl,
          () => authNotifierImpl.signInWithEmailAndPassword(
            tEmail,
            tPassword,
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
          ],
        );

        verify(mockSignInWithEmailAndPassword(
          SignInWithEmailAndPasswordParams(tEmail, tPassword),
        ));
        verifyNoMoreInteractions(mockSignInWithEmailAndPassword);
      },
    );

    test('should throw a [Failure] if usecase fails', () async {
      when(mockSignInWithEmailAndPassword(any))
          .thenAnswer((_) async => Left(tFailure));

      final call = authNotifierImpl.signInWithEmailAndPassword;

      expect(
        () => call(tEmail, tPassword),
        throwsA(isInstanceOf<ServerFailure>()),
      );

      verify(mockSignInWithEmailAndPassword(
        SignInWithEmailAndPasswordParams(tEmail, tPassword),
      ));
      verifyNoMoreInteractions(mockSignInWithEmailAndPassword);
    });
  });

  group('signInWithSocial', () {
    test(
      'should set [User _user] when usecase succeed',
      () async {
        when(mockSignInWithSocial(any)).thenAnswer((_) async => Right(tUser));

        await expectToNotifiyListener<AuthNotifierImpl>(
          authNotifierImpl,
          () => authNotifierImpl.signInWithSocial(SocialLoginType.facebook),
          [
            NotifierAssertParams(
              value: (notifier) => notifier.isLoading,
              matcher: true,
            ),
            NotifierAssertParams(
              value: (notifier) => notifier.isLoading,
              matcher: false,
            ),
          ],
        );

        verify(mockSignInWithSocial(
          SignInWithSocialParams(SocialLoginType.facebook),
        ));
        verifyNoMoreInteractions(mockSignInWithSocial);
      },
    );

    test('should throw a [Failure] if usecase fails', () async {
      when(mockSignInWithSocial(any)).thenAnswer((_) async => Left(tFailure));

      final call = authNotifierImpl.signInWithSocial;

      expect(
        () => call(SocialLoginType.google),
        throwsA(isInstanceOf<ServerFailure>()),
      );

      verify(mockSignInWithSocial(
        SignInWithSocialParams(SocialLoginType.google),
      ));
      verifyNoMoreInteractions(mockSignInWithSocial);
    });
  });

  group('signUp', () {
    test(
      'should set [User _user] when usecase succeed',
      () async {
        when(mockSignUp(any)).thenAnswer((_) async => Right(tUser));

        await expectToNotifiyListener<AuthNotifierImpl>(
          authNotifierImpl,
          () => authNotifierImpl.signUp(tName, tEmail, tPassword),
          [
            NotifierAssertParams(
              value: (notifier) => notifier.isLoading,
              matcher: true,
            ),
            NotifierAssertParams(
              value: (notifier) => notifier.isLoading,
              matcher: false,
            ),
          ],
        );

        verify(mockSignUp(SignUpParams(tName, tEmail, tPassword)));
        verifyNoMoreInteractions(mockSignUp);
      },
    );

    test('should throw a [Failure] if usecase fails', () async {
      when(mockSignUp(any)).thenAnswer((_) async => Left(tFailure));

      final call = authNotifierImpl.signUp;

      expect(
        () => call(tName, tEmail, tPassword),
        throwsA(isInstanceOf<ServerFailure>()),
      );

      verify(mockSignUp(SignUpParams(tName, tEmail, tPassword)));
      verifyNoMoreInteractions(mockSignUp);
    });
  });
}
