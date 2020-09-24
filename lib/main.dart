import 'package:flutter/material.dart';
import 'package:forestMapApp/screens/map.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forest App Map',
      home: HomeScreen(),
    );
  }
}
