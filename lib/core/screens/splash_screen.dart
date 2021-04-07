import 'package:flutter/material.dart';
import 'package:forest_map_app/core/widgets/screen.dart';
import '../widgets/logo.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenWidget(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Logo(),
        ),
      ),
    );
  }
}
