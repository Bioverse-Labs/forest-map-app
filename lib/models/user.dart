import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';

class User {
  String id;
  String name;
  String email;
  String phone;
  String photoUrl;
  auth.User firebaseUser;
  DocumentReference documentReference;

  User({
    @required this.id,
    this.name,
    this.email,
    this.phone,
    this.photoUrl,
    this.firebaseUser,
    this.documentReference,
  });

  factory User.fromFirebase(
    auth.User firebaseUser,
    DocumentSnapshot documentSnapshot,
  ) {
    if (firebaseUser == null) {
      throw Exception('Firebase user not provided!');
    }

    if (!(firebaseUser is auth.User)) {
      throw Exception('Provided user is not Firebase User Type');
    }

    if (documentSnapshot == null) {
      throw Exception('Firebase user not provided!');
    }

    if (!(documentSnapshot is DocumentSnapshot)) {
      throw Exception('Provided user is not Firebase User Type');
    }

    final data = documentSnapshot.data();

    return User(
      id: firebaseUser?.uid,
      name: data['name'] as String,
      email: data['email'] as String,
      phone: data['phone'] as String,
      photoUrl: data['photoUrl'] as String,
      firebaseUser: firebaseUser,
      documentReference: documentSnapshot?.reference,
    );
  }

  factory User.fromDocument(DocumentSnapshot documentSnapshot) {
    if (documentSnapshot == null) {
      throw Exception('Firebase user not provided!');
    }

    if (!(documentSnapshot is DocumentSnapshot)) {
      throw Exception('Provided user is not Firebase User Type');
    }

    final data = documentSnapshot.data();

    return User(
      id: documentSnapshot.id,
      name: data['name'] as String,
      email: data['email'] as String,
      phone: data['phone'] as String,
      photoUrl: data['photoUrl'] as String,
      documentReference: documentSnapshot?.reference,
    );
  }

  bool get emailIsVerified => firebaseUser?.emailVerified;
}
