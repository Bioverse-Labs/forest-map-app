import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class DataNotifier extends ChangeNotifier {
  Position location;
  String name;
  File imgFile;

  void setImage(File file) {
    imgFile = file;
    notifyListeners();
  }

  Future<void> saveAndStorage(String name, Position location) async {
    this.name = name;
    this.location = location;

    // TODO Save data in Hive;
  }
}
