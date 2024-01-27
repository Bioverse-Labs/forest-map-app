import 'package:forest_map/core/domain/entities/auth.dart';
import 'package:forest_map/features/user/data/models/user_model.dart';
import 'package:forest_map/features/user/domain/entities/user.dart';

abstract class AuthAdapter {
  Future<UserModel> signInWithEmailAndPassword(String email, String password);
  Future<UserModel> signInWithCredential(Auth credential);
  Future<UserModel> signUpUserWithEmailAndPassword(
    String email,
    String password,
  );
  Future<void> signOut();
  Future<void> forgotPassword(String email);
  Stream<User?> authStateStream();
}
