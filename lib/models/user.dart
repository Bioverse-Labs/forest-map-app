import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class UserModel extends ChangeNotifier {
  String id;
  String name;
  String email;
  String phone;
  String photoUrl;
  auth.User firebaseUser;
  final auth.FirebaseAuth firebaseAuth;

  UserModel({this.firebaseAuth});

  bool get emailIsVerified => firebaseUser.emailVerified;

  Future<void> createUser({
    String name,
    String email,
    String phone,
    String password,
  }) async {
    try {
      final resp = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on PlatformException catch (err) {
      throw Exception(err.message);
    } catch (err) {
      throw Exception(err.toString());
    }
  }
}
