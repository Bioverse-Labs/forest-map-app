import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:forestMapApp/common/theme.dart';
import 'package:forestMapApp/notifiers/user_notifier.dart';
import 'package:forestMapApp/routes.dart';
import 'package:forestMapApp/services/user.dart';
import 'package:forestMapApp/utils/app_navigator.dart';
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
