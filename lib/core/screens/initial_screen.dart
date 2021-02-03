import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forestMapApp/features/auth/data/models/user_model.dart';
import 'package:forestMapApp/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:provider/provider.dart';

import '../adapters/firebase_auth_adapter.dart';
import '../adapters/firestore_adapter.dart';
import '../navigation/app_navigator.dart';
import 'splash_screen.dart';

class InitialScreen extends StatelessWidget {
  final FirebaseAuthAdapterImpl firebaseAuthAdapterImpl;
  final FirestoreAdapterImpl firestoreAdapterImpl;
  final AppNavigator appNavigator;

  InitialScreen({
    Key key,
    @required this.firebaseAuthAdapterImpl,
    @required this.firestoreAdapterImpl,
    @required this.appNavigator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: firebaseAuthAdapterImpl.firebaseAuth.authStateChanges(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          Future.delayed(
            const Duration(milliseconds: 300),
            () async {
              if (snapshot.data == null) {
                appNavigator.pushAndReplace('/signIn');
              } else {
                final doc = await firestoreAdapterImpl
                    .getDocument('users/${snapshot.data.uid}');
                final user = UserModel.fromMap(doc.data());

                Provider.of<AuthNotifierImpl>(context, listen: false)
                    .setUser(user);
                appNavigator.pushAndReplace('/home');
              }
            },
          );
        }

        return SplashScreen();
      },
    );
  }
}
