import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forest_map_app/core/adapters/database_adapter.dart';

import '../../features/organization/presentation/notifiers/organizations_notifier.dart';
import '../../features/user/presentation/notifiers/user_notifier.dart';
import '../adapters/firebase_auth_adapter.dart';
import '../adapters/firestore_adapter.dart';
import '../errors/failure.dart';
import '../navigation/app_navigator.dart';
import '../platform/network_info.dart';
import '../util/notifications.dart';
import 'splash_screen.dart';

class InitialScreen extends StatelessWidget {
  final FirebaseAuthAdapterImpl firebaseAuthAdapterImpl;
  final FirestoreAdapterImpl firestoreAdapterImpl;
  final AppNavigator appNavigator;
  final UserNotifierImpl userNotifier;
  final OrganizationNotifierImpl organizationNotifier;
  final NetworkInfo networkInfo;
  final NotificationsUtils notificationsUtils;
  final DatabaseAdapter databaseAdapter;

  InitialScreen({
    Key key,
    @required this.firebaseAuthAdapterImpl,
    @required this.firestoreAdapterImpl,
    @required this.appNavigator,
    @required this.userNotifier,
    @required this.organizationNotifier,
    @required this.networkInfo,
    @required this.notificationsUtils,
    @required this.databaseAdapter,
  }) : super(key: key);

  Future<void> _handleStateChange(BuildContext context, User user) async {
    try {
      await databaseAdapter.openDatabase();

      if (user == null) {
        appNavigator.pushAndReplace('/signIn');
        return;
      }

      final isConnected = await networkInfo.isConnected;

      await userNotifier.getUser(
        id: isConnected ? user?.uid : 'currUser',
        searchLocally: !isConnected,
      );
      await organizationNotifier.getOrganization(
        id: 'currOrg',
        searchLocally: true,
      );

      if (isConnected && organizationNotifier?.organization?.id != null) {
        await organizationNotifier.getOrganization(
          id: organizationNotifier?.organization?.id,
          searchLocally: false,
        );
      }

      appNavigator.pushAndReplace('/home');
    } on ServerFailure catch (failure) {
      notificationsUtils.showErrorNotification(failure.message);
    }
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
