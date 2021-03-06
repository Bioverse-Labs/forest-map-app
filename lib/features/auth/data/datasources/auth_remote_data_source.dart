import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:meta/meta.dart';

import '../../../../core/adapters/firebase_auth_adapter.dart';
import '../../../../core/adapters/firestore_adapter.dart';
import '../../../../core/adapters/hive_adapter.dart';
import '../../../../core/enums/exception_origin_types.dart';
import '../../../../core/enums/social_login_types.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/util/localized_string.dart';
import '../../../organization/data/hive/organization.dart';
import '../../../user/data/hive/user.dart';
import '../../../user/data/models/user_model.dart';

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

  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirestoreAdapter firestoreAdapter;
  final FirebaseAuthAdapter firebaseAuthAdapter;
  final LocalizedString localizedString;
  final HiveAdapter<UserHive> userHive;
  final HiveAdapter<OrganizationHive> orgHive;
  AuthRemoteDataSourceImpl({
    @required this.firestoreAdapter,
    @required this.firebaseAuthAdapter,
    @required this.localizedString,
    @required this.userHive,
    @required this.orgHive,
  });

  @override
  Future<UserModel> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return firebaseAuthAdapter.signInWithEmailAndPassword(email, password);
    } on FirebaseAuthException catch (error) {
      throw getServerExceptionFromFirebaseAuth(error, localizedString);
    }
  }

  @override
  Future<UserModel> signInWithSocial(SocialLoginType type) async {
    try {
      AuthCredential credential;
      if (type == SocialLoginType.facebook) {
        credential = await firebaseAuthAdapter.getFacebookAuthCredential();
      } else {
        credential = await firebaseAuthAdapter.getGoogleAuthCredential();
      }

      final authResult =
          await firebaseAuthAdapter.signInWithCredential(credential);

      final docSnapshot =
          await firestoreAdapter.getDocument('users/${authResult.id}');

      if (!docSnapshot.exists) {
        await firestoreAdapter.addDocument(
          'users/${authResult.id}',
          authResult.toMap(),
        );
      }

      return authResult;
    } on FirebaseAuthException catch (error) {
      throw getServerExceptionFromFirebaseAuth(error, localizedString);
    } on FacebookAuthException catch (error) {
      if (error.errorCode != "CANCELLED") {
        throw ServerException(
          localizedString.getLocalizedString('generic-exception'),
          error.errorCode,
          ExceptionOriginTypes.firebaseAuth,
        );
      }
    } on FirebaseException catch (error) {
      throw ServerException(
        localizedString.getLocalizedString('database-exceptions.get-error'),
        error.code,
        ExceptionOriginTypes.firebaseFirestore,
      );
    }

    return null;
  }

  @override
  Future<UserModel> signUp(String name, String email, String password) async {
    try {
      final authResult = await firebaseAuthAdapter
          .signUpUserWithEmailAndPassword(email, password);

      final payload = authResult.toMap();
      payload['name'] = name;

      await firestoreAdapter.addDocument(
        'users/${authResult.id}',
        payload,
      );

      return authResult;
    } on FirebaseAuthException catch (error) {
      throw getServerExceptionFromFirebaseAuth(error, localizedString);
    } on FirebaseException catch (error) {
      throw ServerException(
        localizedString.getLocalizedString('database-exceptions.get-error'),
        error.code,
        ExceptionOriginTypes.firebaseFirestore,
        stackTrace: error.stackTrace,
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await firebaseAuthAdapter.signOut();
      await userHive.deleteAll();
      await orgHive.deleteAll();
    } on FirebaseAuthException catch (error) {
      throw getServerExceptionFromFirebaseAuth(error, localizedString);
    }
  }
}
