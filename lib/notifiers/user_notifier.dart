import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';
import 'package:forestMapApp/services/user.dart';
import 'package:forestMapApp/utils/notifications.dart';
import 'package:forestMapApp/models/user.dart';

class UserNotifier extends ChangeNotifier {
  User user;
  auth.FirebaseAuth firebaseAuth;

  UserNotifier({@required this.firebaseAuth});

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

      this.user = await UserService.createUser(
        firebaseUser: credential.user,
        name: name,
        email: email,
        phone: phone,
      );
    } catch (err) {
      Notifications.showErrorNotification(err.toString());
    } finally {
      BotToast.closeAllLoading();
    }
  }

  void signOut() {
    firebaseAuth.signOut();
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      BotToast.showLoading();
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on auth.FirebaseAuthException catch (err) {
      Notifications.showErrorNotification(err?.message);
    } finally {
      BotToast.closeAllLoading();
    }
  }
}
