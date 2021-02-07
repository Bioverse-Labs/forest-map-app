import 'package:flutter/material.dart';
import 'package:forestMapApp/core/util/localized_string.dart';
import 'package:forestMapApp/core/widgets/screen.dart';

class MapScreen extends StatelessWidget {
  final LocalizedString localizedString;

  MapScreen({Key key, @required this.localizedString}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenWidget(
      body: Container(),
    );
  }
}
