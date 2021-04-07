import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Theme.of(context).brightness == Brightness.light
          ? 'assets/bioverse_black.png'
          : 'assets/bioverse_white.png',
      fit: BoxFit.fill,
      width: double.infinity,
      semanticLabel: 'Company Logo',
    );
  }
}
