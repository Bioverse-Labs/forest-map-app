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
}
