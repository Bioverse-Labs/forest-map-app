import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class UserModel extends ChangeNotifier {
  String id;
  String name;
  String email;
  String phone;
  String photoUrl;
  DocumentReference documentReference;
  auth.User firebaseUser;
  final auth.FirebaseAuth firebaseAuth;

  UserModel({this.firebaseAuth});

  bool get emailIsVerified => firebaseUser.emailVerified;

  Future<void> _createUser({
    String id,
    String name,
    String email,
    String phone,
    String photoUrl,
  }) async {
    try {
      final usersCollectionRef = FirebaseFirestore.instance.collection('users');
      this.documentReference = usersCollectionRef.doc(id);

      await documentReference.set({
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'photoUrl': photoUrl
      });

      // Set the uid from FirebaseAuth as User id in Firestore collection
      this.id = id;
      this.name = name;
      this.email = email;
      this.phone = phone;
      this.photoUrl = photoUrl;

      notifyListeners();
    } on PlatformException catch (err) {
      BotToast.showSimpleNotification(title: err.message);
    } catch (err) {
      BotToast.showSimpleNotification(title: err.toString());
    }
  }

  Future<void> createUserWithEmailAndPassword({
    String name,
    String email,
    String phone,
    String photoUrl,
    String password,
  }) async {
    try {
      BotToast.showLoading();
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _createUser(
        id: credential?.user?.uid,
        name: name,
        email: email,
        phone: phone,
        photoUrl: photoUrl,
      );
    } on PlatformException catch (err) {
      BotToast.showSimpleNotification(title: err.message);
    } catch (err) {
      BotToast.showSimpleNotification(title: err.toString());
    } finally {
      BotToast.closeAllLoading();
    }
  }
}
