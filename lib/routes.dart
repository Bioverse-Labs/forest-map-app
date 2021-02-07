import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'core/adapters/firebase_auth_adapter.dart';
import 'core/errors/failure.dart';
import 'core/navigation/app_navigator.dart';
import 'core/screens/initial_screen.dart';
import 'core/util/notifications.dart';
import 'features/auth/presentation/notifiers/auth_notifier.dart';
import 'features/auth/presentation/screens/sign_in_screen.dart';
import 'features/auth/presentation/screens/sign_up_screen.dart';
import 'features/tracking/presentation/notifiers/location_notifier.dart';
import 'features/user/presentation/notifiers/user_notifier.dart';

Map<String, Widget Function(BuildContext)> routes = {
  '/': (_) => InitialScreen(
        firebaseAuthAdapterImpl: GetIt.I(),
        appNavigator: GetIt.I(),
      ),
  '/signIn': (ctx) => SignInScreen(
        authNotifierImpl: Provider.of<AuthNotifierImpl>(ctx, listen: false),
        userNotifierImpl: Provider.of<UserNotifierImpl>(ctx, listen: false),
        localizedString: GetIt.I(),
        validationUtils: GetIt.I(),
        appTheme: GetIt.I(),
        appNavigator: GetIt.I(),
        notificationsUtils: GetIt.I(),
      ),
  '/signUp': (ctx) => SignupScreen(
        authNotifierImpl: Provider.of<AuthNotifierImpl>(ctx, listen: false),
        userNotifierImpl: Provider.of<UserNotifierImpl>(ctx, listen: false),
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
  }

  Future<void> _startTracking(context) async {
    final userNotifier = Provider.of<UserNotifierImpl>(context, listen: false);
    final locationNotifier =
        Provider.of<LocationNotifierImpl>(context, listen: false);

    try {
      await locationNotifier.startTracking(userNotifier.user.id);
    } on LocationFailure catch (failure) {
      GetIt.I<NotificationsUtils>().showErrorNotification(failure.message);
    }
  }

  void _signOut() {
    GetIt.I<FirebaseAuthAdapterImpl>().firebaseAuth.signOut();
    GetIt.I<AppNavigator>().pushAndReplace('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.red,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                onPressed: () => _startTracking(context),
                child: Text('Start Tracking'),
              ),
              RaisedButton(
                onPressed: _signOut,
                child: Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
