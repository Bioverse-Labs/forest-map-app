import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:forestMapApp/core/enums/exception_origin_types.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/enums/social_login_types.dart';
import '../../../../core/errors/exceptions.dart';
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

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

  AuthRemoteDataSourceImpl(this.firebaseAuth, this.firebaseFirestore);

  @override
  Future<UserModel> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userId = credential.user.uid;
      final snapshot =
          await firebaseFirestore.collection('users').doc(userId).get();

      if (!snapshot.exists) {
        throw ServerException(
          'database-exceptions.get-error'.tr(),
          '404',
          ExceptionOriginTypes.firebaseFirestore,
        );
      }

      final model = UserModel.fromMap(snapshot.data());
      return model;
    } on FirebaseAuthException catch (error) {
      throw getServerExceptionFromFirebaseAuth(error);
    } on FirebaseException catch (error) {
      throw ServerException(
        'database-exceptions.get-error'.tr(),
        error.code,
        ExceptionOriginTypes.firebaseFirestore,
      );
    } catch (error) {
      throw ServerException(
        'generic-exception'.tr(),
        'generic-error',
        ExceptionOriginTypes.firebaseFirestore,
      );
    }
  }

  @override
  Future<UserModel> signInWithSocial(SocialLoginType type) {
    // TODO: implement signInWithSocial
    throw UnimplementedError();
  }

  @override
  Future<UserModel> signUp(String name, String email, String password) {
    // TODO: implement signUp
    throw UnimplementedError();
  }
}
