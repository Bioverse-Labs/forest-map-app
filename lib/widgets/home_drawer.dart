import 'package:flutter/material.dart';
import 'package:forestMapApp/notifiers/user_notifier.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserNotifier>(
      builder: (ctx, user, child) {
        return Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                margin: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Container(),
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('home-drawer.logout').tr(),
                onTap: user.signOut,
              )
            ],
          ),
        );
      },
    );
  }
}
