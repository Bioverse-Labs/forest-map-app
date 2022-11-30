import 'package:flutter/material.dart';
import '../../features/catalog/presentation/notifiers/catalog_notifier.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../features/auth/presentation/notifiers/auth_notifier.dart';
import '../../features/map/presentation/notifiers/map_notifier.dart';
import '../../features/organization/presentation/notifiers/organization_invite_notifier.dart';
import '../../features/organization/presentation/notifiers/organizations_notifier.dart';
import '../../features/post/presentation/notifier/post_notifier.dart';
import '../../features/tracking/presentation/notifiers/location_notifier.dart';
import '../../features/user/presentation/notifiers/user_notifier.dart';
import '../notifiers/home_screen_notifier.dart';

class AppNotifier extends StatelessWidget {
  final Widget widget;

  const AppNotifier({Key key, @required this.widget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthNotifierImpl>(
          create: (_) => GetIt.I(),
        ),
        ChangeNotifierProvider<LocationNotifierImpl>(
          create: (_) => GetIt.I(),
        ),
        ChangeNotifierProvider<OrganizationNotifierImpl>(
          create: (_) => GetIt.I(),
        ),
        ChangeNotifierProvider<OrganizationInviteNotifierImpl>(
          create: (_) => GetIt.I(),
        ),
        ChangeNotifierProvider<UserNotifierImpl>(
          create: (_) => GetIt.I<UserNotifierImpl>(),
        ),
        ChangeNotifierProvider<HomeScreenNotifierImpl>(
          create: (_) => GetIt.I(),
        ),
        ChangeNotifierProvider<PostNotifierImpl>(
          create: (_) => GetIt.I(),
        ),
        ChangeNotifierProvider<MapNotifierImpl>(
          create: (_) => GetIt.I(),
        ),
        ChangeNotifierProvider<CatalogNotifierImpl>(
          create: (_) => GetIt.I(),
        ),
      ],
      child: widget,
    );
  }
}
