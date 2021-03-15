import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../../../core/models/model.dart';
import '../../domain/entities/geolocation_data_properties.dart';
import '../hive/geolocation_data_properties.dart';

class GeolocationDataPropertiesModel extends GeolocationDataProperties
    implements
        Model<GeolocationDataPropertiesModel, GeolocationDataPropertiesHive> {
  GeolocationDataPropertiesModel({
    @required String id,
    @required String type,
    @required String specie,
    @required DateTime detDate,
    @required DateTime imageDate,
    @required double latitude,
    @required double longitude,
  }) : super(
          id: id,
          type: type,
          specie: specie,
          detDate: detDate,
          imageDate: imageDate,
          latitude: latitude,
          longitude: longitude,
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
      latitude: map['latitude'],
      longitude: map['longitude'],
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
      specie: geoProperties.specie,
      latitude: geoProperties.latitude,
      longitude: geoProperties.longitude,
    );
  }

  factory GeolocationDataPropertiesModel.fromHive(
    GeolocationDataPropertiesHive geoPropertiesHive,
  ) {
    return GeolocationDataPropertiesModel(
      id: geoPropertiesHive.id,
      type: geoPropertiesHive.type,
      detDate: geoPropertiesHive.detDate,
      imageDate: geoPropertiesHive.imageDate,
      specie: geoPropertiesHive.specie,
      latitude: geoPropertiesHive.longitude,
      longitude: geoPropertiesHive.longitude,
    );
  }

  @override
  GeolocationDataPropertiesModel copyWith({
    String id,
    String type,
    String specie,
    DateTime detDate,
    DateTime imageDate,
    double latitude,
    double longitude,
  }) {
    return GeolocationDataPropertiesModel(
      id: id ?? this.id,
      type: type ?? this.type,
      specie: specie ?? this.specie,
      detDate: detDate ?? this.detDate,
      imageDate: imageDate ?? this.imageDate,
      latitude: latitude ?? latitude,
      longitude: longitude ?? longitude,
    );
  }

  @override
  GeolocationDataPropertiesHive toHiveAdapter() {
    return GeolocationDataPropertiesHive()
      ..id = id
      ..type = type
      ..specie = specie
      ..detDate = detDate
      ..imageDate = imageDate
      ..latitude = latitude
      ..longitude = longitude;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'specie': specie,
      'detDate': detDate,
      'imageDate': imageDate,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
