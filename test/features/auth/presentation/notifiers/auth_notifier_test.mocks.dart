// Mocks generated by Mockito 5.4.3 from annotations
// in forest_map/test/features/auth/presentation/notifiers/auth_notifier_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:dartz/dartz.dart' as _i2;
import 'package:forest_map/core/errors/failure.dart' as _i5;
import 'package:forest_map/core/usecases/usecase.dart' as _i10;
import 'package:forest_map/features/auth/domain/usecases/forgot_password.dart'
    as _i11;
import 'package:forest_map/features/auth/domain/usecases/sign_in_with_email_and_password.dart'
    as _i3;
import 'package:forest_map/features/auth/domain/usecases/sign_in_with_social.dart'
    as _i7;
import 'package:forest_map/features/auth/domain/usecases/sign_out.dart' as _i9;
import 'package:forest_map/features/auth/domain/usecases/sign_up.dart' as _i8;
import 'package:forest_map/features/user/domain/entities/user.dart' as _i6;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeEither_0<L, R> extends _i1.SmartFake implements _i2.Either<L, R> {
  _FakeEither_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [SignInWithEmailAndPassword].
///
/// See the documentation for Mockito's code generation for more information.
class MockSignInWithEmailAndPassword extends _i1.Mock
    implements _i3.SignInWithEmailAndPassword {
  MockSignInWithEmailAndPassword() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.User>> call(
          _i3.SignInWithEmailAndPasswordParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i6.User>>.value(
            _FakeEither_0<_i5.Failure, _i6.User>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i6.User>>);
}

/// A class which mocks [SignInWithSocial].
///
/// See the documentation for Mockito's code generation for more information.
class MockSignInWithSocial extends _i1.Mock implements _i7.SignInWithSocial {
  MockSignInWithSocial() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.User>> call(
          _i7.SignInWithSocialParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i6.User>>.value(
            _FakeEither_0<_i5.Failure, _i6.User>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i6.User>>);
}

/// A class which mocks [SignUp].
///
/// See the documentation for Mockito's code generation for more information.
class MockSignUp extends _i1.Mock implements _i8.SignUp {
  MockSignUp() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.User>> call(
          _i8.SignUpParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i6.User>>.value(
            _FakeEither_0<_i5.Failure, _i6.User>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i6.User>>);
}

/// A class which mocks [SignOut].
///
/// See the documentation for Mockito's code generation for more information.
class MockSignOut extends _i1.Mock implements _i9.SignOut {
  MockSignOut() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.Failure, void>> call(_i10.NoParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, void>>.value(
            _FakeEither_0<_i5.Failure, void>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, void>>);
}

/// A class which mocks [ForgotPassword].
///
/// See the documentation for Mockito's code generation for more information.
class MockForgotPassword extends _i1.Mock implements _i11.ForgotPassword {
  MockForgotPassword() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.Failure, void>> call(
          _i11.ForgotPasswordParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, void>>.value(
            _FakeEither_0<_i5.Failure, void>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, void>>);
}
