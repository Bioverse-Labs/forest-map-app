import 'package:flutter/material.dart';

import '../../../../core/util/localized_string.dart';
import '../../../../core/widgets/screen.dart';

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
