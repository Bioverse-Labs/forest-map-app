import 'package:flutter/material.dart';

class AppNavigator {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void push(String route, {Object args}) =>
      navigatorKey.currentState.pushNamed(route, arguments: args);

  void pop() => navigatorKey.currentState.pop();

  void pushAndRemove(
    String route,
    bool Function(Route<dynamic> route) predicate,
  ) =>
      navigatorKey.currentState.pushNamedAndRemoveUntil(route, predicate);

  void pushAndReplace(String route) =>
      navigatorKey.currentState.pushReplacementNamed(route);
}
