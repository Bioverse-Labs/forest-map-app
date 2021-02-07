import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/user/presentation/notifiers/user_notifier.dart';
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

  Future<void> _handleStateChange(BuildContext context, User user) async {
    if (user == null) {
      appNavigator.pushAndReplace('/signIn');
      return;
    }

    final userNotifier = Provider.of<UserNotifierImpl>(context, listen: false);
    await userNotifier.getUser(user?.uid);

    appNavigator.pushAndReplace('/home');
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: firebaseAuthAdapterImpl.firebaseAuth.authStateChanges(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          Future.delayed(
            const Duration(milliseconds: 300),
            () => _handleStateChange(context, snapshot.data),
          );
        }

        return SplashScreen();
      },
    );
  }
}
