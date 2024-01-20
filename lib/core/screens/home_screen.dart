import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/auth/presentation/notifiers/auth_notifier.dart';
import '../../features/map/presentation/notifiers/map_notifier.dart';
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
  final LocalizedString? localizedString;
  final HomeScreenNotifierImpl homeScreenNotifier;
  final OrganizationNotifierImpl organizationNotifier;
  final OrganizationInviteNotifierImpl organizationInviteNotifier;
  final LocationNotifierImpl locationNotifier;
  final UserNotifierImpl userNotifier;
  final AuthNotifierImpl authNotifier;
  final PostNotifierImpl postNotifier;
  final MapNotifierImpl mapNotifier;
  final AppNavigator? appNavigator;
  final NotificationsUtils? notificationsUtils;
  final Camera? camera;
  final AppSettings? appSettings;
  final AppTheme? appTheme;
  final NetworkInfo? networkInfo;

  const HomeScreen({
    Key? key,
    required this.localizedString,
    required this.homeScreenNotifier,
    required this.organizationNotifier,
    required this.organizationInviteNotifier,
    required this.locationNotifier,
    required this.mapNotifier,
    required this.appNavigator,
    required this.userNotifier,
    required this.authNotifier,
    required this.postNotifier,
    required this.notificationsUtils,
    required this.camera,
    required this.appSettings,
    required this.appTheme,
    required this.networkInfo,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Widget> _widgetOptions;
  StreamSubscription<DataConnectionStatus>? _connectionStream;

  @override
  void dispose() {
    super.dispose();
    _connectionStream?.cancel();
    widget.locationNotifier.stream?.cancel();
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
        mapNotifier: widget.mapNotifier,
      ),
      OrganizationScreen(
        localizedString: widget.localizedString,
        organizationNotifier: widget.organizationNotifier,
        postNotifier: widget.postNotifier,
        userNotifier: widget.userNotifier,
        appNavigator: widget.appNavigator,
        camera: widget.camera,
        notificationsUtils: widget.notificationsUtils,
      ),
      ProfileScreen(
        authNotifier: widget.authNotifier,
        userNotifier: widget.userNotifier,
        organizationNotifier: widget.organizationNotifier,
        homeScreenNotifierImpl: widget.homeScreenNotifier,
        camera: widget.camera,
        localizedString: widget.localizedString,
        appNavigator: widget.appNavigator,
        notificationsUtils: widget.notificationsUtils,
      ),
    ];

    _connectionStream =
        widget.networkInfo!.connectionStatusStream.asBroadcastStream().listen(
      (status) {
        if (status == DataConnectionStatus.connected) {
          try {
            widget.postNotifier.uploadCachedPost();
          } catch (error) {
            if (error is ServerFailure) {
              widget.notificationsUtils!.showErrorNotification(error.message);
              return;
            }

            if (error is LocalFailure) {
              widget.notificationsUtils!.showErrorNotification(error.message);
              return;
            }

            if (error is LocationFailure) {
              widget.notificationsUtils!.showErrorNotification(error.message);
              return;
            }

            widget.notificationsUtils!.showErrorNotification(error.toString());
          }
        } else {
          widget.postNotifier.cancelUpload();
        }
      },
    );

    if (widget.organizationInviteNotifier.showScreen) {
      final userOrganizations = widget.userNotifier.user!.organizations;
      final alreadyMember = userOrganizations?.firstWhereOrNull(
        (e) => e.id == widget.organizationInviteNotifier.organizationId,
      );

      if (userOrganizations != null && alreadyMember != null) {
        widget.organizationInviteNotifier.setInviteScreenVisibility(false);
      } else {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          widget.appNavigator!.push('/organization-invite');
          widget.organizationInviteNotifier.setInviteScreenVisibility(false);
        });
      }
    }

    widget.organizationInviteNotifier.addListener(() {
      final showScreen = widget.organizationInviteNotifier.showScreen;
      final userOrganizations = widget.userNotifier.user!.organizations;
      final alreadyMember = userOrganizations?.firstWhereOrNull(
        (e) => e.id == widget.organizationInviteNotifier.organizationId,
      );

      if (showScreen) {
        if (userOrganizations != null && alreadyMember != null) {
          widget.organizationInviteNotifier.setInviteScreenVisibility(false);
        } else {
          widget.appNavigator!.push('/organization-invite');
          widget.organizationInviteNotifier.setInviteScreenVisibility(false);
        }
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _getData();
      widget.locationNotifier.trackUser(widget.userNotifier.user?.id);
      widget.organizationNotifier.addListener(_getData);
    });

    super.initState();
  }

  Future<void> _getData() async {
    final organization = widget.organizationNotifier.organization;

    if (organization != null && !widget.organizationNotifier.isLoading) {
      try {
        await Future.wait([
          widget.mapNotifier.downloadGeoData(organization),
          widget.mapNotifier.getBoundary(organization),
          widget.mapNotifier.getVillages(organization),
          widget.locationNotifier.getLocations(widget.userNotifier.user!.id),
        ]);
      } on LocalFailure catch (failure) {
        widget.notificationsUtils!.showErrorNotification(failure.message);
      } on ServerFailure catch (failure) {
        widget.notificationsUtils!.showErrorNotification(failure.message);
      } on NoInternetFailure catch (_) {
        widget.notificationsUtils!.showInfoNotification(
          widget.localizedString!.getLocalizedString('no-internet'),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Consumer<HomeScreenNotifierImpl>(
              builder: (ctx, state, _) {
                return _widgetOptions.elementAt(state.activeTabIndex);
              },
            ),
            Consumer<PostNotifierImpl>(
              builder: (ctx, state, child) {
                if (state.cachedPostsAmount != state.postsAmount) {
                  return child!;
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
      ),
      bottomNavigationBar: Consumer<HomeScreenNotifierImpl>(
        builder: (ctx, state, _) {
          return BottomNavigationBar(
            currentIndex: state.activeTabIndex,
            onTap: widget.homeScreenNotifier.setActiveTab,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.map_outlined),
                label: widget.localizedString!.getLocalizedString(
                  'home-screen.map-tab',
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.group_work_outlined),
                label: widget.localizedString!.getLocalizedString(
                  'home-screen.organization-tab',
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: widget.localizedString!.getLocalizedString(
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
