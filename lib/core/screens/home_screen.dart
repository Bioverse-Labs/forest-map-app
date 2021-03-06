import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/auth/presentation/notifiers/auth_notifier.dart';
import '../../features/map/presentation/screens/map_screen.dart';
import '../../features/organization/presentation/notifiers/organization_invite_notifier.dart';
import '../../features/organization/presentation/notifiers/organizations_notifier.dart';
import '../../features/organization/presentation/screens/organization_screen.dart';
import '../../features/post/presentation/notifier/post_notifier.dart';
import '../../features/post/presentation/widgets/cached_post_upload_modal.dart';
import '../../features/tracking/presentation/notifiers/location_notifier.dart';
import '../../features/user/presentation/notifiers/user_notifier.dart';
import '../../features/user/presentation/screen/profile_screen.dart';
import '../errors/failure.dart';
import '../navigation/app_navigator.dart';
import '../notifiers/home_screen_notifier.dart';
import '../platform/camera.dart';
import '../platform/network_info.dart';
import '../style/theme.dart';
import '../util/localized_string.dart';
import '../util/notifications.dart';

class HomeScreen extends StatefulWidget {
  final LocalizedString localizedString;
  final HomeScreenNotifierImpl homeScreenNotifier;
  final OrganizationNotifierImpl organizationNotifier;
  final OrganizationInviteNotifierImpl organizationInviteNotifier;
  final LocationNotifierImpl locationNotifier;
  final UserNotifierImpl userNotifier;
  final AuthNotifierImpl authNotifier;
  final PostNotifierImpl postNotifier;
  final AppNavigator appNavigator;
  final NotificationsUtils notificationsUtils;
  final Camera camera;
  final AppSettings appSettings;
  final AppTheme appTheme;
  final NetworkInfo networkInfo;

  const HomeScreen({
    Key key,
    @required this.localizedString,
    @required this.homeScreenNotifier,
    @required this.organizationNotifier,
    @required this.organizationInviteNotifier,
    @required this.locationNotifier,
    @required this.appNavigator,
    @required this.userNotifier,
    @required this.authNotifier,
    @required this.postNotifier,
    @required this.notificationsUtils,
    @required this.camera,
    @required this.appSettings,
    @required this.appTheme,
    @required this.networkInfo,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> _widgetOptions;
  StreamSubscription<DataConnectionStatus> _connectionStream;

  @override
  void dispose() {
    super.dispose();
    _connectionStream?.cancel();
  }

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
        camera: widget.camera,
        organizationNotifier: widget.organizationNotifier,
        postNotifier: widget.postNotifier,
        appTheme: widget.appTheme,
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
        homeScreenNotifierImpl: widget.homeScreenNotifier,
        camera: widget.camera,
        localizedString: widget.localizedString,
        appNavigator: widget.appNavigator,
        notificationsUtils: widget.notificationsUtils,
      ),
    ];

    _connectionStream =
        widget.networkInfo.connectionStatusStream.asBroadcastStream().listen(
      (status) {
        if (status == DataConnectionStatus.connected) {
          try {
            widget.postNotifier.uploadCachedPost();
          } catch (error) {
            if (error is ServerFailure) {
              widget.notificationsUtils.showErrorNotification(error.message);
              return;
            }

            if (error is LocalFailure) {
              widget.notificationsUtils.showErrorNotification(error.message);
              return;
            }

            if (error is LocationFailure) {
              widget.notificationsUtils.showErrorNotification(error.message);
              return;
            }

            widget.notificationsUtils.showErrorNotification(error.toString());
          }
        } else {
          widget.postNotifier.cancelUpload();
        }
      },
    );

    if (widget.organizationInviteNotifier.showScreen) {
      final userOrganizations = widget.userNotifier.user.organizations;
      final alreadyMember = userOrganizations?.firstWhere(
        (e) => e.id == widget.organizationInviteNotifier.organizationId,
        orElse: () => null,
      );

      if (userOrganizations != null && alreadyMember != null) {
        widget.organizationInviteNotifier.setInviteScreenVisibility(false);
      } else {
        Future.delayed(const Duration(milliseconds: 600), () {
          widget.appNavigator.push('/organization-invite');
          widget.organizationInviteNotifier.setInviteScreenVisibility(false);
        });
      }
    }

    widget.organizationInviteNotifier.addListener(() {
      final showScreen = widget.organizationInviteNotifier.showScreen;
      final userOrganizations = widget.userNotifier.user.organizations;
      final alreadyMember = userOrganizations?.firstWhere(
        (e) => e.id == widget.organizationInviteNotifier.organizationId,
        orElse: () => null,
      );

      if (showScreen) {
        if (userOrganizations != null && alreadyMember != null) {
          widget.organizationInviteNotifier.setInviteScreenVisibility(false);
        } else {
          widget.appNavigator.push('/organization-invite');
          widget.organizationInviteNotifier.setInviteScreenVisibility(false);
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          IndexedStack(
            index: Provider.of<HomeScreenNotifierImpl>(context).activeTabIndex,
            children: _widgetOptions,
          ),
          Consumer<PostNotifierImpl>(
            builder: (ctx, state, child) {
              if (state.cachedPostsAmount != state.postsAmount) {
                return child;
              }

              return Container();
            },
            child: Align(
              alignment: Alignment.topLeft,
              child: CachedPostUploadModal(
                appTheme: widget.appTheme,
                size: MediaQuery.of(context).size,
              ),
            ),
          ),
        ],
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
