import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';

class User {
  String id;
  String name;
  String email;
  String phone;
  String photoUrl;
  auth.User firebaseUser;

  User({
    @required this.id,
    this.name,
    this.email,
    this.phone,
    this.photoUrl,
    this.firebaseUser,
  });

  factory User.fromFirebase(auth.User firebaseUser) {
    if (firebaseUser == null) {
      throw Exception('Firebase user not provided!');
    }

    if (!(firebaseUser is auth.User)) {
      throw Exception('Provided user is not Firebase User Type');
    }

    return User(
      id: firebaseUser?.uid,
      name: firebaseUser?.displayName,
      email: firebaseUser?.email,
      phone: firebaseUser?.phoneNumber,
      photoUrl: firebaseUser?.photoURL,
      firebaseUser: firebaseUser,
    );
  }
}
