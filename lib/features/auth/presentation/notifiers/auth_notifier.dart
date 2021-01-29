import 'package:flutter/foundation.dart';

import '../../../../core/enums/social_login_types.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/sign_in_with_email_and_password.dart';
import '../../domain/usecases/sign_in_with_social.dart';
import '../../domain/usecases/sign_up.dart';

abstract class AuthNotifier {
  Future<void> signInWithEmailAndPassword(String email, String password);
  Future<void> signInWithSocial(SocialLoginType type);
  Future<void> signUp(String name, String email, String password);
}

class AuthNotifierImpl extends ChangeNotifier implements AuthNotifier {
  final SignInWithEmailAndPassword signInWithEmailAndPasswordUseCase;
  final SignInWithSocial signInWithSocialUseCase;
  final SignUp signUpUseCase;
  User _user;
  bool _loading = false;

  User get user => _user;
  bool get isLoading => _loading;

  AuthNotifierImpl(
    this.signInWithEmailAndPasswordUseCase,
    this.signInWithSocialUseCase,
    this.signUpUseCase,
  );

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    this._loading = true;
    notifyListeners();

    final failureOrUser = await signInWithEmailAndPasswordUseCase(
      SignInWithEmailAndPasswordParams(email, password),
    );

    this._loading = false;
    notifyListeners();

    failureOrUser.fold(
      (failure) => throw failure,
      (user) {
        this._user = user;
        notifyListeners();
      },
    );
  }

  @override
  Future<void> signInWithSocial(SocialLoginType type) async {
    this._loading = true;
    notifyListeners();

    final failureOrUser =
        await signInWithSocialUseCase(SignInWithSocialParams(type));

    this._loading = false;
    notifyListeners();

    failureOrUser.fold(
      (failure) => throw failure,
      (user) {
        this._user = user;
        notifyListeners();
      },
    );
  }

  @override
  Future<void> signUp(String name, String email, String password) async {
    this._loading = true;
    notifyListeners();

    final failureOrUser =
        await signUpUseCase(SignUpParams(name, email, password));

    this._loading = false;
    notifyListeners();

    failureOrUser.fold(
      (failure) => throw failure,
      (user) {
        this._user = user;
        notifyListeners();
      },
    );
  }
}
