import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

import 'core/config/app_config.dart';
import 'core/config/app_notifier.dart';
import 'core/widgets/app.dart';
import 'generated/codegen_loader.g.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ForestMap());
}

class ForestMap extends StatefulWidget {
  const ForestMap({Key key}) : super(key: key);

  @override
  _ForestMapState createState() => _ForestMapState();
}

class _ForestMapState extends State<ForestMap> {
  Future<void> _initApp() async {
    await AppConfig.initEssentialServices();
    AppConfig.registerHiveAdapters();
    AppConfig.registerUtils();
    AppConfig.registerPlatformServices();
    AppConfig.registerStyles();
    AppConfig.registerNavigation();
    AppConfig.registerAdapters();
    await AppConfig.initHiveAdapters();
    AppConfig.registerDatasources();
    AppConfig.registerRepositories();
    AppConfig.registerUseCases();
    AppConfig.registerNotifiers();
    await Jiffy.locale(); // en
  }

  @override
  void dispose() {
    AppConfig.disposeHiveAdapters();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      child: FutureBuilder(
        future: _initApp(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }

          return AppNotifier(
            widget: App(),
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
