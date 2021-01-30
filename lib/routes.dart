import 'package:flutter/material.dart';

import 'core/screens/initial_screen.dart';

Map<String, Widget Function(BuildContext)> routes = {
  '/': (_) => InitialScreen(),
};
