import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:forestMapApp/core/errors/exceptions.dart';

import '../../../../core/enums/social_login_types.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  /// use [FirebaseAuth.instance] and calls signInWithEmailAndPassword method
  /// if succeeded search for document in [FirebaseFirestore.instance] user's
  /// colection and returns it's data.
  ///
  /// Throws [ServerException] for all errors.
  Future<UserModel> signInWithEmailAndPassword(
    String email,
    String password,
  );

  /// creates an credential based on argument [SocialLoginType type]
  /// and use [FirebaseAuth.instance] and calls signInWithCredential method
  /// if succeeded search for document in user's collection with same [uuid]
  /// if document does not exist creates new document with
  /// [FirebaseFirestore.instance] inside user's collection and returns
  /// it's data.
  ///
  /// Throws [ServerException] for all errors.
  Future<UserModel> signInWithSocial(SocialLoginType type);

  /// use [FirebaseAuth.instance] and calls createUserWithEmailAndPassword
  /// method if succeeded creates an document in [FirebaseFirestore.instance]
  /// inside user's collection and returns it's data.
  ///
  /// Throws [ServerException] for all errors.
  Future<UserModel> signUp(
    String name,
    String email,
    String password,
  );
}
