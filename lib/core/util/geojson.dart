import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:geojson/geojson.dart';

class GeoJsonUtils {
  Future<GeoJson> parseFromFile(File file) async {
    final geoJson = GeoJson();
    await geoJson.parseFile(file.path);

    return geoJson;
  }

  Future<GeoJson> parseFromString(String path) async {
    final geoJson = GeoJson();
    final data = await rootBundle.loadString('assets/test.geojson');

    await geoJson.parse(data);
    return geoJson;
  }
}
