import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/auth/presentation/notifiers/auth_notifier.dart';
import '../../features/map/presentation/screens/map_screen.dart';
import '../../features/organization/presentation/notifiers/organizations_notifier.dart';
import '../../features/organization/presentation/screens/organization_screen.dart';
import '../../features/tracking/presentation/notifiers/location_notifier.dart';
import '../../features/user/presentation/notifiers/user_notifier.dart';
import '../../features/user/presentation/screen/profile_screen.dart';
import '../navigation/app_navigator.dart';
import '../notifiers/home_screen_notifier.dart';
import '../platform/camera.dart';
import '../util/localized_string.dart';
import '../util/notifications.dart';

class HomeScreen extends StatefulWidget {
  final LocalizedString localizedString;
  final HomeScreenNotifierImpl homeScreenNotifier;
  final OrganizationNotifierImpl organizationNotifier;
  final LocationNotifierImpl locationNotifier;
  final UserNotifierImpl userNotifier;
  final AuthNotifierImpl authNotifier;
  final AppNavigator appNavigator;
  final NotificationsUtils notificationsUtils;
  final Camera camera;
  final AppSettings appSettings;

  const HomeScreen({
    Key key,
    @required this.localizedString,
    @required this.homeScreenNotifier,
    @required this.organizationNotifier,
    @required this.locationNotifier,
    @required this.appNavigator,
    @required this.userNotifier,
    @required this.authNotifier,
    @required this.notificationsUtils,
    @required this.camera,
    @required this.appSettings,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> _widgetOptions;

  @override
  void initState() {
    _widgetOptions = <Widget>[
      MapScreen(
        locationNotifier: widget.locationNotifier,
        userNotifier: widget.userNotifier,
        localizedString: widget.localizedString,
        notificationsUtils: widget.notificationsUtils,
        appNavigator: widget.appNavigator,
        appSettings: widget.appSettings,
      ),
      OrganizationScreen(
        localizedString: widget.localizedString,
        organizationNotifier: widget.organizationNotifier,
        userNotifier: widget.userNotifier,
        appNavigator: widget.appNavigator,
        camera: widget.camera,
        notificationsUtils: widget.notificationsUtils,
      ),
      ProfileScreen(
        authNotifier: widget.authNotifier,
        userNotifier: widget.userNotifier,
        camera: widget.camera,
        localizedString: widget.localizedString,
        appNavigator: widget.appNavigator,
        notificationsUtils: widget.notificationsUtils,
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: Provider.of<HomeScreenNotifierImpl>(context).activeTabIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: Consumer<HomeScreenNotifierImpl>(
        builder: (ctx, state, _) {
          return BottomNavigationBar(
            currentIndex: state.activeTabIndex,
            onTap: widget.homeScreenNotifier.setActiveTab,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.map_outlined),
                label: widget.localizedString.getLocalizedString(
                  'home-screen.map-tab',
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.group_work_outlined),
                label: widget.localizedString.getLocalizedString(
                  'home-screen.organization-tab',
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: widget.localizedString.getLocalizedString(
                  'home-screen.profile-tab',
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
