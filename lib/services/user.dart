import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:forestMapApp/models/user.dart';
import 'package:forestMapApp/utils/notifications.dart';

class UserService {
  static Future<User> createUser({
    auth.User firebaseUser,
    String name,
    String email,
    String phone,
    String photoUrl,
  }) async {
    try {
      final usersCollectionRef = FirebaseFirestore.instance.collection('users');
      final documentReference = usersCollectionRef.doc(firebaseUser?.uid);

      await documentReference.set({
        'id': firebaseUser?.uid,
        'name': name,
        'email': email,
        'phone': phone,
        'photoUrl': photoUrl
      });

      final documentSnapshot = await documentReference.get();
      return User.fromFirebase(firebaseUser, documentSnapshot);
    } on auth.FirebaseException catch (err) {
      Notifications.showErrorNotification(err.message);
    } catch (err) {
      Notifications.showErrorNotification(err.toString());
    }

    return null;
  }

  static Future<User> getUser(String id) async {
    try {
      final usersCollectionRef = FirebaseFirestore.instance.collection('users');
      final documentSnapshot = await usersCollectionRef.doc(id).get();
      User user;

      if (documentSnapshot.exists) {
        user = User.fromDocument(documentSnapshot);
      }

      final firebaseUser = auth.FirebaseAuth.instance.currentUser;

      if (firebaseUser?.uid == user.id) {
        user.firebaseUser = firebaseUser;
      }

      return user;
    } on auth.FirebaseException catch (err) {
      Notifications.showErrorNotification(err.message);
    } catch (err) {
      Notifications.showErrorNotification(err.toString());
    }

    return null;
  }

  static Future<User> updateUser(
    String id,
    Map<String, dynamic> payload,
  ) async {
    try {
      final usersCollectionRef = FirebaseFirestore.instance.collection('users');

      await usersCollectionRef.doc(id).update(payload);
      final user = await getUser(id);

      final firebaseUser = auth.FirebaseAuth.instance.currentUser;

      if (firebaseUser?.uid == user.id) {
        user.firebaseUser = firebaseUser;
      }

      return user;
    } on auth.FirebaseException catch (err) {
      Notifications.showErrorNotification(err.message);
    } catch (err) {
      Notifications.showErrorNotification(err.toString());
    }

    return null;
  }

  static Future<User> createUserWithSocialSignIn(auth.User firebaseUser) async {
    try {
      User user = await getUser(firebaseUser?.uid);

      if (user == null) {
        user = await createUser(
          firebaseUser: firebaseUser,
          email: firebaseUser?.email,
          name: firebaseUser?.displayName,
          phone: firebaseUser?.phoneNumber,
          photoUrl: firebaseUser?.photoURL,
        );
      } else {
        user = await updateUser(
          firebaseUser?.uid,
          {
            'photoUrl': firebaseUser?.photoURL,
          },
        );
      }

      return user;
    } on auth.FirebaseException catch (err) {
      Notifications.showErrorNotification(err.message);
    } catch (err) {
      Notifications.showErrorNotification(err.toString());
    }

    return null;
  }
}
