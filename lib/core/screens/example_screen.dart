import 'package:flutter/material.dart';
import '../widgets/screen.dart';

class ExampleScreen extends StatelessWidget {
  const ExampleScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenWidget(
      appBar: AppBar(),
    );
  }
}
