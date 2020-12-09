import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:forestMapApp/app.dart';
import 'package:forestMapApp/generated/codegen_loader.g.dart';
import 'package:forestMapApp/notifiers/user_notifier.dart';
import 'package:forestMapApp/utils/app_navigator.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

void main() {
  GetIt.I.registerLazySingleton<AppNavigator>(() => AppNavigator());
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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }

          return ChangeNotifierProvider(
            create: (_) => UserNotifier(firebaseAuth: FirebaseAuth.instance),
            child: App(),
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
