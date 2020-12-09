import 'package:flutter/material.dart';

class AppNavigator {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void pushWidget(Widget widget) => navigatorKey.currentState
      .push(MaterialPageRoute(builder: (context) => widget));

  void pop() => navigatorKey.currentState.pop();

  void pushAndRemoveWidget(
    Widget widget,
    bool Function(Route<dynamic> route) predicate,
  ) =>
      navigatorKey.currentState.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => widget,
        ),
        predicate,
      );

  void pushReplacementWidget(Widget widget) => navigatorKey.currentState
      .pushReplacement(MaterialPageRoute(builder: (context) => widget));
}
