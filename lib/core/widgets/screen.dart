import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'loading_wall.dart';

class ScreenWidget<T extends ChangeNotifier> extends StatelessWidget {
  final PreferredSizeWidget appBar;
  final Widget body;
  final List<Widget> children;
  final Widget floatingActionButton;
  final FloatingActionButtonLocation floatingActionButtonLocation;
  final bool isLoading;
  final Color backgrounColor;
  final EdgeInsets padding;

  ScreenWidget({
    Key key,
    this.appBar,
    this.body,
    this.children = const <Widget>[],
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.isLoading = false,
    this.padding = const EdgeInsets.all(0),
    this.backgrounColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).brightness == Brightness.light
            ? Colors.black
            : Colors.white,
        statusBarBrightness: Theme.of(context).brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
      ),
      child: Scaffold(
        appBar: appBar,
        backgroundColor: backgrounColor,
        body: SafeArea(
          child: Padding(
            padding: padding,
            child: Stack(
              children: [
                if (body != null) body,
                ...children,
                if (isLoading) LoadingWall(),
              ],
            ),
          ),
        ),
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
      ),
    );
  }
}
