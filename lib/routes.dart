import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'core/notifiers/home_screen_notifier.dart';
import 'core/screens/home_screen.dart';
import 'core/screens/initial_screen.dart';
import 'features/auth/presentation/notifiers/auth_notifier.dart';
import 'features/auth/presentation/screens/sign_in_screen.dart';
import 'features/auth/presentation/screens/sign_up_screen.dart';
import 'features/map/presentation/notifiers/map_notifier.dart';
import 'features/map/presentation/screens/static_map_screen.dart';
import 'features/organization/presentation/notifiers/organization_invite_notifier.dart';
import 'features/organization/presentation/notifiers/organizations_notifier.dart';
import 'features/organization/presentation/screens/organization_invite_screen.dart';
import 'features/post/presentation/notifier/post_notifier.dart';
import 'features/tracking/presentation/notifiers/location_notifier.dart';
import 'features/user/presentation/notifiers/user_notifier.dart';

Map<String, Widget Function(BuildContext)> routes = {
  '/': (ctx) => InitialScreen(
        firebaseAuthAdapterImpl: GetIt.I(),
        userNotifier: Provider.of<UserNotifierImpl>(ctx, listen: false),
        organizationNotifier: Provider.of<OrganizationNotifierImpl>(
          ctx,
          listen: false,
        ),
        firestoreAdapterImpl: GetIt.I(),
        appNavigator: GetIt.I(),
        networkInfo: GetIt.I(),
        notificationsUtils: GetIt.I(),
      ),
  '/signIn': (ctx) => SignInScreen(
        authNotifier: Provider.of<AuthNotifierImpl>(ctx, listen: false),
        userNotifier: Provider.of<UserNotifierImpl>(ctx, listen: false),
        organizationNotifier: Provider.of<OrganizationNotifierImpl>(
          ctx,
          listen: false,
        ),
        localizedString: GetIt.I(),
        validationUtils: GetIt.I(),
        appTheme: GetIt.I(),
        appNavigator: GetIt.I(),
        notificationsUtils: GetIt.I(),
      ),
  '/signUp': (ctx) => SignupScreen(
        authNotifierImpl: Provider.of<AuthNotifierImpl>(ctx, listen: false),
        userNotifierImpl: Provider.of<UserNotifierImpl>(ctx, listen: false),
        organizationNotifier: Provider.of<OrganizationNotifierImpl>(
          ctx,
          listen: false,
        ),
        localizedString: GetIt.I(),
        validationUtils: GetIt.I(),
        appTheme: GetIt.I(),
        appNavigator: GetIt.I(),
        notificationsUtils: GetIt.I(),
      ),
  '/home': (ctx) => HomeScreen(
        localizedString: GetIt.I(),
        homeScreenNotifier: Provider.of<HomeScreenNotifierImpl>(
          ctx,
          listen: false,
        ),
        organizationNotifier: Provider.of<OrganizationNotifierImpl>(
          ctx,
          listen: false,
        ),
        organizationInviteNotifier: Provider.of<OrganizationInviteNotifierImpl>(
          ctx,
          listen: false,
        ),
        userNotifier: Provider.of<UserNotifierImpl>(ctx, listen: false),
        authNotifier: Provider.of<AuthNotifierImpl>(ctx, listen: false),
        locationNotifier: Provider.of<LocationNotifierImpl>(ctx, listen: false),
        postNotifier: Provider.of<PostNotifierImpl>(ctx, listen: false),
        mapNotifier: Provider.of<MapNotifierImpl>(ctx, listen: false),
        appNavigator: GetIt.I(),
        notificationsUtils: GetIt.I(),
        camera: GetIt.I(),
        appSettings: GetIt.I(),
        appTheme: GetIt.I(),
        networkInfo: GetIt.I(),
      ),
  '/organization-invite': (ctx) => OrganizationInviteScreen(
        organizationInviteNotifier: Provider.of<OrganizationInviteNotifierImpl>(
          ctx,
          listen: false,
        ),
        organizationNotifier: Provider.of<OrganizationNotifierImpl>(
          ctx,
          listen: false,
        ),
        userNotifier: Provider.of<UserNotifierImpl>(ctx, listen: false),
        notificationsUtils: GetIt.I(),
        localizedString: GetIt.I(),
        appNavigator: GetIt.I(),
      ),
  '/organization-geolocation-data-map': (ctx) => StaticMapScreen(
        organizationNotifier: Provider.of<OrganizationNotifierImpl>(
          ctx,
          listen: false,
        ),
      ),
};
