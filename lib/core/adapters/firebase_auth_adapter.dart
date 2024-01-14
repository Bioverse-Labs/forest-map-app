import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:forest_map/core/adapters/auth_adapter.dart';
import 'package:forest_map/features/user/domain/entities/user.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../features/user/data/models/user_model.dart';

class FirebaseAuthAdapterImpl implements AuthAdapter {
  final auth.FirebaseAuth? firebaseAuth;
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
  Future<auth.AuthCredential> getFacebookAuthCredential() async {
    final res = await facebookAuth!.login();
    final credential = await socialCredentialAdapter!
        .getFacebookCredential(res.accessToken!.token);
    return credential;
  }

  @override
  Future<auth.AuthCredential> getGoogleAuthCredential() async {
    final googleAuth = (await (await googleSignIn!.signIn())?.authentication)!;
    final credential = await socialCredentialAdapter!.getGoogleCredential(
      googleAuth.accessToken,
      googleAuth.idToken,
    );

    return credential;
  }

  @override
  Future<UserModel> signInWithCredential(auth.AuthCredential credential) async {
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

  @override
  Stream<User?> authStateStream() {
    return firebaseAuth!.authStateChanges().map(
          (event) => User(
            id: event?.uid,
            name: event?.displayName,
            email: event?.email,
            avatarUrl: event?.photoURL,
          ),
        );
  }
}

abstract class SocialCredentialAdapter {
  Future<auth.AuthCredential> getFacebookCredential(String token);
  Future<auth.AuthCredential> getGoogleCredential(
      String? accessToken, String? idToken);
}

class SocialCredentialAdapterImpl implements SocialCredentialAdapter {
  @override
  Future<auth.AuthCredential> getFacebookCredential(String token) async =>
      auth.FacebookAuthProvider.credential(token);

  @override
  Future<auth.AuthCredential> getGoogleCredential(
    String? accessToken,
    String? idToken,
  ) async =>
      auth.GoogleAuthProvider.credential(
          accessToken: accessToken, idToken: idToken);
}
