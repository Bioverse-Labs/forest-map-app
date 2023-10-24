import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:forest_map/core/adapters/auth_adapter.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../features/user/data/models/user_model.dart';

class FirebaseAuthAdapterImpl implements AuthAdapter {
  final FirebaseAuth? firebaseAuth;
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
  Future<AuthCredential> getFacebookAuthCredential() async {
    final res = await facebookAuth!.login();
    final credential = await socialCredentialAdapter!
        .getFacebookCredential(res.accessToken!.token);
    return credential;
  }

  @override
  Future<AuthCredential> getGoogleAuthCredential() async {
    final googleAuth = (await (await googleSignIn!.signIn())?.authentication)!;
    final credential = await socialCredentialAdapter!.getGoogleCredential(
      googleAuth.accessToken,
      googleAuth.idToken,
    );

    return credential;
  }

  @override
  Future<UserModel> signInWithCredential(AuthCredential credential) async {
    final result = await firebaseAuth!.signInWithCredential(credential);
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
}

abstract class SocialCredentialAdapter {
  Future<AuthCredential> getFacebookCredential(String token);
  Future<AuthCredential> getGoogleCredential(
      String? accessToken, String? idToken);
}

class SocialCredentialAdapterImpl implements SocialCredentialAdapter {
  @override
  Future<AuthCredential> getFacebookCredential(String token) async =>
      FacebookAuthProvider.credential(token);

  @override
  Future<AuthCredential> getGoogleCredential(
    String? accessToken,
    String? idToken,
  ) async =>
      GoogleAuthProvider.credential(accessToken: accessToken, idToken: idToken);
}
