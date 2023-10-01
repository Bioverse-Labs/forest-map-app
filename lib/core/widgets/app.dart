import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../features/organization/presentation/notifiers/organization_invite_notifier.dart';
import '../../routes.dart';
import '../navigation/app_navigator.dart';
import '../style/theme.dart';
import '../util/notifications.dart';

class App extends StatefulWidget {
  final Iterable<LocalizationsDelegate<dynamic>> localizationsDelegate;
  final List<Locale> supportedLocales;

  App({
    Key? key,
    required this.localizationsDelegate,
    required this.supportedLocales,
  }) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final AppTheme? _appTheme = GetIt.I<AppTheme>();
  final AppNavigator? _appNavigator = GetIt.I<AppNavigator>();

  @override
  void initState() {
    super.initState();
    _handleDynamicLink();
  }

  Future<void> _handleDynamicLink() async {
    final notifier =
        Provider.of<OrganizationInviteNotifierImpl>(context, listen: false);
    final NotificationsUtils? notificationUtils = GetIt.I<NotificationsUtils>();

    try {
      final linkData = await FirebaseDynamicLinks.instance.getInitialLink();

      if (linkData != null) {
        final uri = linkData.link;
        final orgId = uri.queryParameters['orgId'];
        notifier.setOrgId(orgId);
      }
    } catch (error) {
      notificationUtils!.showErrorNotification(error.toString());
    }

    FirebaseDynamicLinks.instance.onLink.listen(
      (PendingDynamicLinkData dynamicLink) async {
        final Uri deepLink = dynamicLink.link;

        final orgId = deepLink.queryParameters['orgId'];

        if (orgId != null) {
          notifier.setOrgId(orgId);
        }
      },
      onError: (e) async {
        notificationUtils!.showErrorNotification(e.message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forest App Map',
      theme: _appTheme!.getMainTheme.copyWith(
        textTheme: GoogleFonts.nunitoTextTheme(Theme.of(context).textTheme),
      ),
      darkTheme: _appTheme!.getDarkTheme.copyWith(
        textTheme: GoogleFonts.nunitoTextTheme(Theme.of(context).textTheme),
      ),
      builder: BotToastInit(),
      navigatorKey: _appNavigator!.navigatorKey,
      navigatorObservers: [BotToastNavigatorObserver()],
      initialRoute: '/',
      routes: routes,
      localizationsDelegates: widget.localizationsDelegate,
      supportedLocales: widget.supportedLocales,
    );
  }
}
