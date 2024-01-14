import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;

import '../../features/user/data/models/user_model.dart';
import '../../features/user/domain/entities/user.dart';

abstract class AuthAdapter {
  Future<UserModel> signInWithEmailAndPassword(String email, String password);
  Future<UserModel> signInWithCredential(
      firebaseAuth.AuthCredential credential);
  Future<UserModel> signUpUserWithEmailAndPassword(
    String email,
    String password,
  );
  Future<firebaseAuth.AuthCredential> getGoogleAuthCredential();
  Future<firebaseAuth.AuthCredential> getFacebookAuthCredential();
  Future<void> signOut();
  Future<void> forgotPassword(String email);
  Stream<User?> authStateStream();
}
