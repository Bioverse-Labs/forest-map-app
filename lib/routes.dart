import 'package:flutter/material.dart';
import 'package:forestMapApp/core/adapters/firebase_auth_adapter.dart';
import 'package:forestMapApp/core/navigation/app_navigator.dart';
import 'package:forestMapApp/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:forestMapApp/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:forestMapApp/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'core/screens/initial_screen.dart';

Map<String, Widget Function(BuildContext)> routes = {
  '/': (_) => InitialScreen(
        firebaseAuthAdapterImpl: GetIt.I(),
        appNavigator: GetIt.I(),
      ),
  '/signIn': (ctx) => SignInScreen(
        authNotifierImpl: Provider.of<AuthNotifierImpl>(ctx, listen: false),
        localizedString: GetIt.I(),
        validationUtils: GetIt.I(),
        appTheme: GetIt.I(),
        appNavigator: GetIt.I(),
        notificationsUtils: GetIt.I(),
      ),
  '/signUp': (ctx) => SignupScreen(
        authNotifierImpl: Provider.of<AuthNotifierImpl>(ctx, listen: false),
        localizedString: GetIt.I(),
        validationUtils: GetIt.I(),
        appTheme: GetIt.I(),
        appNavigator: GetIt.I(),
        notificationsUtils: GetIt.I(),
      ),
  '/home': (ctx) => TempWidget(),
};

class TempWidget extends StatefulWidget {
  const TempWidget({Key key}) : super(key: key);

  @override
  _TempWidgetState createState() => _TempWidgetState();
}

class _TempWidgetState extends State<TempWidget> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 200), () {
      GetIt.I<FirebaseAuthAdapterImpl>().firebaseAuth.signOut();
      GetIt.I<AppNavigator>().pushAndReplace('/');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.red,
      ),
    );
  }
}
