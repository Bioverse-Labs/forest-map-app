import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

import '../../../../core/models/model.dart';
import '../../../../core/util/localized_string.dart';
import '../../../../core/util/notifications.dart';
import '../../domain/entities/geolocation_data_properties.dart';
import '../hive/geolocation_data_properties.dart';
import '../hive/lat_lng.dart';
import '../hive/polygon.dart';

class GeolocationDataPropertiesModel extends GeolocationDataProperties
    implements
        Model<GeolocationDataPropertiesModel, GeolocationDataPropertiesHive> {
  GeolocationDataPropertiesModel({
    @required String id,
    @required String type,
    @required String specie,
    @required DateTime detDate,
    @required DateTime imageDate,
    @required Polygon polygon,
  }) : super(
          id: id,
          type: type,
          specie: specie,
          detDate: detDate,
          imageDate: imageDate,
          polygon: polygon,
        );

  factory GeolocationDataPropertiesModel.fromMap(Map<String, dynamic> map) {
    return GeolocationDataPropertiesModel(
      id: map['id'].toString(),
      type: map['class'],
      specie: map['specie'],
      detDate: map['det_date'] != null ? DateTime.parse(map['det_date']) : null,
      imageDate: map['det_date'] != null
          ? DateTime.parse(map['image_date'].toString().replaceAll('/', '-'))
          : null,
      polygon: map['polygon'],
    );
  }

  factory GeolocationDataPropertiesModel.fromEntity(
    GeolocationDataProperties geoProperties,
  ) {
    return GeolocationDataPropertiesModel(
      id: geoProperties.id,
      type: geoProperties.type,
      detDate: geoProperties.detDate,
      imageDate: geoProperties.imageDate,
      polygon: geoProperties.polygon,
      specie: geoProperties.specie,
    );
  }

  factory GeolocationDataPropertiesModel.fromHive(
    GeolocationDataPropertiesHive geoPropertiesHive,
  ) {
    String _getString(String key) =>
        GetIt.I<LocalizedString>().getLocalizedString(key);

    return GeolocationDataPropertiesModel(
      id: geoPropertiesHive.id,
      type: geoPropertiesHive.type,
      detDate: geoPropertiesHive.detDate,
      imageDate: geoPropertiesHive.imageDate,
      polygon: Polygon(
        polygonId: PolygonId(geoPropertiesHive.polygon.id),
        onTap: () {
          return GetIt.I<NotificationsUtils>().showAlertDialog(
            title: Text(
              '${geoPropertiesHive.type}',
              style: TextStyle(fontSize: 28),
            ),
            content: Container(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        '${_getString('polygon-alert.specie-label')}: ${geoPropertiesHive.specie ?? ''}'),
                    Divider(),
                    Text(
                      '${_getString('polygon-alert.date-label')}: ${geoPropertiesHive.imageDate.toString()}',
                    ),
                  ],
                ),
              ),
            ),
            buttons: [AlertButtonParams(title: 'Ok', isPrimary: true)],
          );
        },
        consumeTapEvents: true,
        fillColor: Colors.blue.withOpacity(0.4),
        strokeColor: Colors.blue,
        strokeWidth: 1,
        points: geoPropertiesHive.polygon.points
            .map((e) => LatLng(e.latitude, e.longitude))
            .toList(),
      ),
      specie: geoPropertiesHive.specie,
    );
  }

  @override
  GeolocationDataPropertiesModel copyWith({
    String id,
    String type,
    String specie,
    DateTime detDate,
    DateTime imageDate,
    Polygon polygon,
  }) {
    return GeolocationDataPropertiesModel(
      id: id ?? this.id,
      type: type ?? this.type,
      specie: specie ?? this.specie,
      detDate: detDate ?? this.detDate,
      imageDate: imageDate ?? this.imageDate,
      polygon: polygon ?? this.polygon,
    );
  }

  @override
  GeolocationDataPropertiesHive toHiveAdapter() {
    final polygonHive = PolygonHive()
      ..id = polygon.polygonId.value
      ..points = polygon.points
          .map<LatLngHive>(
            (e) => LatLngHive()
              ..latitude = e.latitude
              ..longitude = e.longitude,
          )
          .toList();

    return GeolocationDataPropertiesHive()
      ..id = id
      ..type = type
      ..specie = specie
      ..detDate = detDate
      ..imageDate = imageDate
      ..polygon = polygonHive;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'specie': specie,
      'detDate': detDate,
      'imageDate': imageDate,
      'polygon': polygon,
    };
  }
}
