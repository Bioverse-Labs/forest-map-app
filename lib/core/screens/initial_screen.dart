import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../adapters/firebase_auth_adapter.dart';
import '../navigation/app_navigator.dart';
import 'splash_screen.dart';

class InitialScreen extends StatelessWidget {
  final FirebaseAuthAdapterImpl firebaseAuthAdapterImpl;
  final AppNavigator appNavigator;

  InitialScreen({
    Key key,
    @required this.firebaseAuthAdapterImpl,
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
            () {
              if (snapshot.data == null) {
                appNavigator.pushAndReplace('/signIn');
              } else {
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
