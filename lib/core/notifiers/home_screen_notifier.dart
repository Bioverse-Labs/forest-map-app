import 'package:flutter/material.dart';

abstract class HomeScreenNotifier {
  void setActiveTab(int index);
}

class HomeScreenNotifierImpl extends ChangeNotifier
    implements HomeScreenNotifier {
  int _index = 0;

  int get activeTabIndex => _index;

  @override
  void setActiveTab(int index) {
    _index = index;
    notifyListeners();
  }
}
