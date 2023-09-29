import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/enums/social_login_types.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../user/domain/entities/user.dart';
import '../../domain/usecases/forgot_password.dart';
import '../../domain/usecases/sign_in_with_email_and_password.dart';
import '../../domain/usecases/sign_in_with_social.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/sign_up.dart';

abstract class AuthNotifier {
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<User> signInWithSocial(SocialLoginType type);
  Future<User> signUp(String name, String email, String password);
  Future<void> signOut();
  Future<void> forgotPassword(String email);
}

class AuthNotifierImpl extends ChangeNotifier implements AuthNotifier {
  final SignInWithEmailAndPassword? signInWithEmailAndPasswordUseCase;
  final SignInWithSocial? signInWithSocialUseCase;
  final SignUp? signUpUseCase;
  final SignOut? signOutUseCase;
  final ForgotPassword? forgotPasswordUseCase;
  bool _loading = false;

  bool get isLoading => _loading;

  AuthNotifierImpl(
    this.signInWithEmailAndPasswordUseCase,
    this.signInWithSocialUseCase,
    this.signUpUseCase,
    this.signOutUseCase,
    this.forgotPasswordUseCase,
  );

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    this._loading = true;
    notifyListeners();

    final failureOrUser = await signInWithEmailAndPasswordUseCase!(
      SignInWithEmailAndPasswordParams(email, password),
    );

    this._loading = false;
    notifyListeners();

    return failureOrUser.fold(
      (failure) => throw failure,
      (user) {
        return user;
      },
    );
  }

  @override
  Future<User> signInWithSocial(SocialLoginType type) async {
    this._loading = true;
    notifyListeners();

    final failureOrUser =
        await signInWithSocialUseCase!(SignInWithSocialParams(type));

    this._loading = false;
    notifyListeners();

    return failureOrUser.fold(
      (failure) => throw failure,
      (user) {
        return user;
      },
    );
  }

  @override
  Future<User> signUp(String name, String email, String password) async {
    this._loading = true;
    notifyListeners();

    final failureOrUser =
        await signUpUseCase!(SignUpParams(name, email, password));

    this._loading = false;
    notifyListeners();

    return failureOrUser.fold(
      (failure) => throw failure,
      (user) {
        return user;
      },
    );
  }

  @override
  Future<void> signOut() async {
    final Either<Failure, void>? failureOrVoid =
        await signOutUseCase!(NoParams());

    failureOrVoid?.fold(
      (failure) => throw failure,
      (r) => r,
    );
  }

  @override
  Future<void> forgotPassword(String email) async {
    this._loading = true;
    notifyListeners();

    final Either<Failure, void>? failureOrVoid =
        await forgotPasswordUseCase!(ForgotPasswordParams(email));

    this._loading = false;
    notifyListeners();

    return failureOrVoid?.fold(
      (failure) => throw failure,
      (r) => r,
    );
  }
}
