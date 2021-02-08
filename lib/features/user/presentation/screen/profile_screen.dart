import 'package:flutter/material.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../../../../core/util/notifications.dart';
import '../../../../core/widgets/screen.dart';
import '../../../auth/presentation/notifiers/auth_notifier.dart';

class ProfileScreen extends StatelessWidget {
  final AuthNotifierImpl authNotifier;
  final AppNavigator appNavigator;
  final NotificationsUtils notificationsUtils;

  const ProfileScreen({
    Key key,
    @required this.authNotifier,
    @required this.appNavigator,
    @required this.notificationsUtils,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return ScreenWidget(
      body: Center(
        child: RaisedButton(
          onPressed: () {
            try {
              authNotifier.signOut();
              appNavigator.pushAndReplace('/');
            } on ServerFailure catch (failure) {
              notificationsUtils.showErrorNotification(failure.message);
            } on LocalFailure catch (failure) {
              notificationsUtils.showErrorNotification(failure.message);
            }
          },
          child: Text('Sign Out'),
        ),
      ),
    );
  }
}
