import 'package:flutter/material.dart';

import 'core/config/app_config.dart';
import 'core/config/notifier.dart';
import 'core/widgets/app.dart';

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
    return FutureBuilder(
      future: _initApp(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }

        return AppNotifier(
          widget: App(),
        );
      },
    );
  }
}
