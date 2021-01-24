import 'package:flutter/material.dart';
import 'package:forestMapApp/screens/home_screen.dart';
import 'package:forestMapApp/screens/login_screen.dart';
import 'package:forestMapApp/screens/preview_screen.dart';
import 'package:forestMapApp/screens/signup_screen.dart';
import 'package:forestMapApp/screens/splash_screen.dart';

Map<String, Widget Function(BuildContext)> routes = {
  '/splash': (ctx) => SplashScreen(),
  '/login': (ctx) => LoginScreen(),
  '/signUp': (ctx) => SignupScreen(),
  '/home': (ctx) => HomeScreen(),
  '/preview': (ctx) => PreviewScreen(),
};
