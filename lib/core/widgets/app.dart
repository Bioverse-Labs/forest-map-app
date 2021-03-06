import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../features/organization/presentation/notifiers/organization_invite_notifier.dart';
import '../../routes.dart';
import '../navigation/app_navigator.dart';
import '../style/theme.dart';
import '../util/notifications.dart';

class App extends StatefulWidget {
  App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final _appTheme = GetIt.I<AppTheme>();
  final _appNavigator = GetIt.I<AppNavigator>();

  @override
  void initState() {
    super.initState();

    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData dynamicLink) async {
        final Uri deepLink = dynamicLink?.link;

        final orgId = deepLink.queryParameters['orgId'];

        if (orgId != null) {
          Provider.of<OrganizationInviteNotifierImpl>(context, listen: false)
              .setOrgId(orgId);
        }
      },
      onError: (OnLinkErrorException e) async {
        GetIt.I<NotificationsUtils>().showErrorNotification(e.message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forest App Map',
      theme: _appTheme.getMainTheme,
      darkTheme: _appTheme.getDarkTheme,
      builder: BotToastInit(),
      navigatorKey: _appNavigator.navigatorKey,
      navigatorObservers: [BotToastNavigatorObserver()],
      initialRoute: '/',
      routes: routes,
    );
  }
}
