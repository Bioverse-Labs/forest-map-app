import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'core/config/app_config.dart';
import 'core/config/app_notifier.dart';
import 'core/widgets/app.dart';
import 'generated/codegen_loader.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await _initApp();
  runApp(EasyLocalization(
    child: ForestMap(),
    supportedLocales: [Locale('en'), Locale('pt', 'BR')],
    fallbackLocale: Locale('en'),
    path: 'translations/',
    assetLoader: CodegenLoader(),
  ));
}

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
}

class ForestMap extends StatefulWidget {
  const ForestMap({Key? key}) : super(key: key);

  @override
  _ForestMapState createState() => _ForestMapState();
}

class _ForestMapState extends State<ForestMap> {
  @override
  void dispose() {
    AppConfig.disposeHiveAdapters();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppNotifier(
      widget: App(
        localizationsDelegate: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
      ),
    );
  }
}
