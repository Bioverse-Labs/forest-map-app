import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:forestMapApp/screens/map.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key key}) : super(key: key);

  final _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        return MaterialApp(
          title: 'Forest App Map',
          home: HomeScreen(),
        );
      },
    );
  }
}
