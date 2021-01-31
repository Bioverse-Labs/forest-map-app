import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'core/config/app_config.dart';
import 'core/config/app_notifier.dart';
import 'core/widgets/app.dart';
import 'generated/codegen_loader.g.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ForestMap());
}

class ForestMap extends StatelessWidget {
  const ForestMap({Key key}) : super(key: key);

  Future<void> _initApp() async {
    await AppConfig.initEssentialServices();
    AppConfig.registerHiveAdapters();
    AppConfig.registerUtils();
    AppConfig.registerPlatformServices();
    AppConfig.registerStyles();
    AppConfig.registerNavigation();
    AppConfig.registerAdapters();
    AppConfig.registerDatasources();
    AppConfig.registerRepositories();
    AppConfig.registerUseCases();
    AppConfig.registerNotifiers();
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
