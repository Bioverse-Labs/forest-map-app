import 'package:flutter/material.dart';
import 'package:forestMapApp/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:provider/provider.dart';

class AppNotifier extends StatelessWidget {
  final Widget widget;

  const AppNotifier({Key key, @required this.widget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthNotifierImpl>(
          create: (_) => GetIt.I(),
        )
      ],
      child: widget,
    );
  }
}
