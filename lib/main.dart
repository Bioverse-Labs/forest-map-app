import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:forestMapApp/common/theme.dart';
import 'package:forestMapApp/generated/codegen_loader.g.dart';
import 'package:forestMapApp/models/user.dart';
import 'package:forestMapApp/screens/signup_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key key}) : super(key: key);

  final _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      child: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          return MaterialApp(
            title: 'Forest App Map',
            theme: mainTheme,
            darkTheme: darkTheme,
            builder: BotToastInit(), //1. call BotToastInit
            navigatorObservers: [BotToastNavigatorObserver()],
            home: ChangeNotifierProvider(
              create: (_) => UserModel(firebaseAuth: FirebaseAuth.instance),
              builder: (ctx, child) {
                return SignupScreen();
              },
            ),
          );
        },
      ),
      supportedLocales: [Locale('en'), Locale('pt', 'BR')],
      fallbackLocale: Locale('en'),
      path: 'translations/',
      assetLoader: CodegenLoader(),
    );
  }
}
