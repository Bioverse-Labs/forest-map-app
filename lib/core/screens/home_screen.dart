import 'package:flutter/material.dart';
import 'package:forestMapApp/core/notifiers/home_screen_notifier.dart';
import 'package:forestMapApp/core/util/localized_string.dart';
import 'package:forestMapApp/features/organization/presentation/notifiers/organizations_notifier.dart';
import 'package:forestMapApp/features/organization/presentation/screens/organization_screen.dart';
import 'package:forestMapApp/features/user/presentation/notifiers/user_notifier.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final LocalizedString localizedString;
  final HomeScreenNotifierImpl homeScreenNotifier;
  final OrganizationNotifierImpl organizationNotifier;
  final UserNotifierImpl userNotifierImpl;

  const HomeScreen({
    Key key,
    @required this.localizedString,
    @required this.homeScreenNotifier,
    @required this.organizationNotifier,
    @required this.userNotifierImpl,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> _widgetOptions;

  @override
  void initState() {
    _widgetOptions = <Widget>[
      Placeholder(),
      OrganizationScreen(
        localizedString: widget.localizedString,
        organizationNotifier: widget.organizationNotifier,
        userNotifier: widget.userNotifierImpl,
      ),
      Placeholder(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(
        Provider.of<HomeScreenNotifierImpl>(context).activeTabIndex,
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
