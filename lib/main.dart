import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'core/register_hive_adapters.dart';
import 'core/register_singletons.dart';
import 'generated/codegen_loader.g.dart';
import 'notifiers/data_notifier.dart';
import 'notifiers/user_notifier.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key key}) : super(key: key);

  Future<void> _initApp() async {
    await Firebase.initializeApp();
    await Hive.initFlutter();
    registerHiveAdapters();
    registerSingletons();
  }

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      child: FutureBuilder(
        future: _initApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen();
          }

          return MultiProvider(
            providers: [
              ChangeNotifierProvider<UserNotifier>(
                create: (_) =>
                    UserNotifier(firebaseAuth: FirebaseAuth.instance),
              ),
              ChangeNotifierProvider<DataNotifier>(
                create: (_) => DataNotifier(),
              ),
            ],
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
