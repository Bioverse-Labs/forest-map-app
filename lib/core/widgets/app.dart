import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../routes.dart';
import '../navigation/app_navigator.dart';
import '../style/theme.dart';

class App extends StatelessWidget {
  final _appTheme = GetIt.I<AppTheme>();
  final _appNavigator = GetIt.I<AppNavigator>();

  App({Key key}) : super(key: key);

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
