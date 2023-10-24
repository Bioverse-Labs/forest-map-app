import 'package:firebase_auth/firebase_auth.dart';

import '../../features/user/data/models/user_model.dart';

abstract class AuthAdapter {
  Future<UserModel> signInWithEmailAndPassword(String email, String password);
  Future<UserModel> signInWithCredential(AuthCredential credential);
  Future<UserModel> signUpUserWithEmailAndPassword(
    String email,
    String password,
  );
  Future<AuthCredential> getGoogleAuthCredential();
  Future<AuthCredential> getFacebookAuthCredential();
  Future<void> signOut();
  Future<void> forgotPassword(String email);
}
