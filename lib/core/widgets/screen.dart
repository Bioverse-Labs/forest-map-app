import 'package:flutter/material.dart';

import 'loading_wall.dart';

class ScreenWidget<T extends ChangeNotifier> extends StatelessWidget {
  final PreferredSizeWidget appBar;
  final Widget body;
  final List<Widget> children;
  final Widget floatingActionButton;
  final FloatingActionButtonLocation floatingActionButtonLocation;
  final bool isLoading;

  ScreenWidget({
    Key key,
    this.appBar,
    this.body,
    this.children = const <Widget>[],
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Stack(
        children: [
          if (body != null) body,
          ...children,
          if (isLoading) LoadingWall(),
        ],
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}
