import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:forestMapApp/services/user.dart';
import 'package:forestMapApp/utils/notifications.dart';
import 'package:forestMapApp/models/user.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserNotifier extends ChangeNotifier {
  User user;
  auth.FirebaseAuth firebaseAuth;

  UserNotifier({@required this.firebaseAuth, user});

  bool get hasUser => user != null;

  void setUser(User _user) {
    user = _user;
    notifyListeners();
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

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

      final googleAuth = await googleUser.authentication;
      final credential = auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final resp = await firebaseAuth.signInWithCredential(credential);

      this.user = await UserService.createUserWithSocialSignIn(resp?.user);
    } on auth.FirebaseAuthException catch (err) {
      Notifications.showErrorNotification(err?.message);
    } on PlatformException catch (err) {
      Notifications.showErrorNotification(err.message);
    } catch (err) {
      Notifications.showErrorNotification(err.toString());
    } finally {
      BotToast.closeAllLoading();
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      BotToast.showLoading();
      final result = await FacebookAuth.instance.login();

      final credential = auth.FacebookAuthProvider.credential(result?.token);

      final resp = await firebaseAuth.signInWithCredential(credential);

      this.user = await UserService.createUserWithSocialSignIn(resp?.user);
    } on auth.FirebaseAuthException catch (err) {
      Notifications.showErrorNotification(err?.message);
    } on PlatformException catch (err) {
      Notifications.showErrorNotification(err.message);
    } catch (err) {
      Notifications.showErrorNotification(err.toString());
    } finally {
      BotToast.closeAllLoading();
    }
  }
}
