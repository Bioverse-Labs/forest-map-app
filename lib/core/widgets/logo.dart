import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final bool white;

  const Logo({
    Key key,
    this.white = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      white
          ? 'assets/bioverse_white.png'
          : Theme.of(context).brightness == Brightness.light
              ? 'assets/bioverse_black.png'
              : 'assets/bioverse_white.png',
      fit: BoxFit.fill,
      width: double.infinity,
      semanticLabel: 'Company Logo',
    );
  }
}
