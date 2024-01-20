import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:forest_map/core/domain/adapters/auth_adapter.dart';
import 'package:forest_map/core/domain/adapters/social_credential_adapter.dart';
import 'package:forest_map/core/domain/entities/auth.dart';
import 'package:forest_map/features/user/domain/entities/user.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../features/user/data/models/user_model.dart';

class FirebaseAuthAdapterImpl implements AuthAdapter {
  final firebase.FirebaseAuth? firebaseAuth;
  final GoogleSignIn? googleSignIn;
  final FacebookAuth? facebookAuth;
  final SocialCredentialAdapter? socialCredentialAdapter;

  FirebaseAuthAdapterImpl(
    this.firebaseAuth,
    this.googleSignIn,
    this.facebookAuth,
    this.socialCredentialAdapter,
  );

  @override
  Future<Auth> getFacebookAuthCredential() async {
    final res = await facebookAuth!.login();
    final credential = await socialCredentialAdapter!
        .getFacebookCredential(res.accessToken!.token);

    return Auth(
      providerId: credential.providerId,
      signInMethod: credential.signInMethod,
      token: credential.token,
      accessToken: credential.accessToken,
    );
  }

  @override
  Future<Auth> getGoogleAuthCredential() async {
    final googleAuth = (await (await googleSignIn!.signIn())?.authentication)!;
    final credential = await socialCredentialAdapter!.getGoogleCredential(
      googleAuth.accessToken,
      googleAuth.idToken,
    );

    return Auth(
      providerId: credential.providerId,
      signInMethod: credential.signInMethod,
      token: credential.token,
      accessToken: credential.accessToken,
    );
  }

  @override
  Future<UserModel> signInWithCredential(Auth auth) async {
    final result = await firebaseAuth!.signInWithCredential(
      firebase.AuthCredential(
        providerId: auth.providerId,
        signInMethod: auth.signInMethod,
        token: auth.token,
        accessToken: auth.accessToken,
      ),
    );

    return UserModel(
      id: result.user!.uid,
      name: result.user!.displayName!,
      email: result.user!.email,
      avatarUrl: result.user!.photoURL,
    );
  }

  @override
  Future<UserModel> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final result = await firebaseAuth!.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return UserModel(
      id: result.user!.uid,
      name: result.user!.displayName ?? '',
      email: result.user!.email ?? '',
      avatarUrl: result.user!.photoURL ?? '',
    );
  }

  @override
  Future<UserModel> signUpUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final result = await firebaseAuth!.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return UserModel(
      id: result.user!.uid,
      name: result.user!.displayName ?? '',
      email: result.user!.email ?? '',
      avatarUrl: result.user!.photoURL ?? '',
    );
  }

  @override
  Future<void> signOut() => firebaseAuth!.signOut();

  @override
  Future<void> forgotPassword(String email) {
    return firebaseAuth!.sendPasswordResetEmail(email: email);
  }

  @override
  Stream<User?> authStateStream() {
    return firebaseAuth!.authStateChanges().map(
          (event) => event != null
              ? User(
                  id: event.uid,
                  name: event.displayName,
                  email: event.email,
                  avatarUrl: event.photoURL,
                )
              : null,
        );
  }
}
