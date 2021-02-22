import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:forestMapApp/core/style/theme.dart';
import 'package:forestMapApp/core/util/localized_string.dart';
import 'package:forestMapApp/core/util/notifications.dart';
import 'package:forestMapApp/features/map/data/models/geolocation_data_properties_model.dart';
import 'package:geojson/geojson.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  Future<List<GeolocationDataPropertiesModel>> parseFeaturesToModel(
    GeoJsonFeature feature,
  ) async {
    final geoProperties = <GeolocationDataPropertiesModel>[];
    final multiPoly = feature.geometry as GeoJsonMultiPolygon;
    String _getString(String key) =>
        GetIt.I<LocalizedString>().getLocalizedString(key);

    for (var poly in multiPoly.polygons) {
      final points = <LatLng>[];

      for (var serie in poly.geoSeries) {
        for (var point in serie.geoPoints) {
          points.add(LatLng(point.latitude, point.longitude));
        }
      }

      final polygon = Polygon(
        polygonId: PolygonId(poly.name),
        fillColor: Colors.blue.withOpacity(0.4),
        strokeColor: Colors.blue,
        strokeWidth: 1,
        points: points,
        consumeTapEvents: true,
        onTap: () => GetIt.I<NotificationsUtils>().showAlertDialog(
          title: Text(
            '${feature.properties['class']}',
            style: TextStyle(fontSize: 28),
          ),
          content: Container(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '${_getString('polygon-alert.specie-label')}: ${feature.properties['specie'] ?? ''}'),
                  Divider(),
                  Text(
                    '${_getString('polygon-alert.date-label')}: ${DateTime.parse(feature.properties['image_date'].toString().replaceAll('/', '-')).toString()}',
                  ),
                ],
              ),
            ),
          ),
          buttons: [AlertButtonParams(title: 'Ok', isPrimary: true)],
        ),
      );

      geoProperties.add(GeolocationDataPropertiesModel.fromMap({
        ...feature.properties,
        'polygon': polygon,
      }));
    }

    return Future.value(geoProperties);
  }
}
