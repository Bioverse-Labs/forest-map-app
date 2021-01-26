import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:forestMapApp/core/adapters/firestore_adapter.dart';
import 'core/theme.dart';
import 'notifiers/user_notifier.dart';
import 'routes.dart';
import 'services/user.dart';
import 'core/app_navigator.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  const App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    final _notifier = Provider.of<UserNotifier>(context, listen: false);
    final _appNavigator = GetIt.I<AppNavigator>();
    _notifier?.firebaseAuth?.authStateChanges()?.asBroadcastStream()?.listen(
      (auth.User firebaseUser) async {
        if (firebaseUser == null) {
          _appNavigator.pushAndReplace('/login');
          return;
        }

        final user = await UserService.getUser(firebaseUser?.uid);
        _notifier.setUser(user);
        _appNavigator.pushAndReplace('/home');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forest App Map',
      theme: mainTheme,
      darkTheme: darkTheme,
      builder: BotToastInit(),
      navigatorKey: GetIt.I<AppNavigator>().navigatorKey,
      navigatorObservers: [BotToastNavigatorObserver()],
      initialRoute: '/splash',
      routes: routes,
    );
  }
}
