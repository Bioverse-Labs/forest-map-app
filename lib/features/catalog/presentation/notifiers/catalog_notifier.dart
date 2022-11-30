import 'package:flutter/cupertino.dart';

import '../../data/catalog.dart';
import '../../domain/entities/catalog.dart';

abstract class CatalogNotifier {
  void setState(int index);
}

class CatalogNotifierImpl extends ChangeNotifier implements CatalogNotifier {
  int _index;
  Map<int, Catalog> items = catalogList;

  int get currentIndex => _index;

  @override
  void setState(int index) {
    _index = index;
    notifyListeners();
  }
}
