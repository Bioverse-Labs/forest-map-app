import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forest_map_app/core/platform/location.dart';
import 'package:geolocator/geolocator.dart';
import '../../features/post/presentation/notifier/post_notifier.dart';

import '../../features/organization/presentation/notifiers/organizations_notifier.dart';
import '../../features/user/presentation/notifiers/user_notifier.dart';
import '../adapters/database_adapter.dart';
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
  final PostNotifier postNotifier;
  final NetworkInfo networkInfo;
  final NotificationsUtils notificationsUtils;
  final DatabaseAdapter databaseAdapter;
  final LocationSource locationSource;

  InitialScreen({
    Key key,
    @required this.firebaseAuthAdapterImpl,
    @required this.firestoreAdapterImpl,
    @required this.appNavigator,
    @required this.userNotifier,
    @required this.organizationNotifier,
    @required this.postNotifier,
    @required this.networkInfo,
    @required this.notificationsUtils,
    @required this.databaseAdapter,
    @required this.locationSource,
  }) : super(key: key);

  Future<void> _handleStateChange(BuildContext context, User user) async {
    try {
      await databaseAdapter.openDatabase();
    } catch (error) {
      notificationsUtils
          .showErrorNotification(error?.message ?? error.toString());
    }

    if (user == null) {
      appNavigator.pushAndReplace('/signIn');
      return;
    }

    try {
      final isConnected = await networkInfo.isConnected;

      final locationPermission = await locationSource.checkPermission();

      if (locationPermission == LocationPermission.denied) {
        appNavigator.pushAndReplace('/ask-location');
        return;
      }

      await userNotifier.getUser(
        id: isConnected ? user?.uid : 'currUser',
        searchLocally: !isConnected,
      );
      await organizationNotifier.getOrganization(
        id: 'currOrg',
        searchLocally: true,
      );

      if (organizationNotifier?.organization?.id != null) {
        if (isConnected) {
          await organizationNotifier.getOrganization(
            id: organizationNotifier?.organization?.id,
            searchLocally: false,
          );
        }
      }

      postNotifier.getPosts(organizationNotifier?.organization?.id);
    } on ServerFailure catch (failure) {
      notificationsUtils.showErrorNotification(failure.message);
    } on LocalFailure catch (failure) {
      notificationsUtils.showErrorNotification(failure.message);
    } catch (error) {
      notificationsUtils.showErrorNotification(error.toString());
    }

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
