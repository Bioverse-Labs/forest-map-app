import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/preview_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/splash_screen.dart';

Map<String, Widget Function(BuildContext)> routes = {
  '/splash': (ctx) => SplashScreen(),
  '/login': (ctx) => LoginScreen(),
  '/signUp': (ctx) => SignupScreen(),
  '/home': (ctx) => HomeScreen(),
  '/preview': (ctx) => PreviewScreen(),
};
