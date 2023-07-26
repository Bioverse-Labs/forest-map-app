import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/entities/geolocation_data_properties.dart';

class GeolocationDataPropertiesModel extends GeolocationDataProperties {
  GeolocationDataPropertiesModel({
    required String id,
    required String geohash,
    required String? type,
    required String? specie,
    required DateTime? detDate,
    required DateTime? imageDate,
    required double? latitude,
    required double? longitude,
    String? name,
    List<LatLng>? points,
  }) : super(
          id: id,
          geohash: geohash,
          type: type,
          specie: specie,
          detDate: detDate,
          imageDate: imageDate,
          latitude: latitude,
          longitude: longitude,
          points: points,
          name: name,
        );

  factory GeolocationDataPropertiesModel.fromMap(Map<String, dynamic> map) {
    return GeolocationDataPropertiesModel(
      id: map['id'].toString(),
      geohash: map['geohash'].toString(),
      type: map['class'],
      specie: map['specie'],
      detDate: map['det_date'] != null ? DateTime.parse(map['det_date']) : null,
      imageDate: map['det_date'] != null
          ? DateTime.parse(map['image_date'].toString().replaceAll('/', '-'))
          : null,
      latitude: map['latitude'],
      longitude: map['longitude'],
      points: map['points'],
      name: map["etnia_nome"],
    );
  }

  factory GeolocationDataPropertiesModel.fromEntity(
    GeolocationDataProperties geoProperties,
  ) {
    return GeolocationDataPropertiesModel(
      id: geoProperties.id,
      geohash: geoProperties.geohash,
      type: geoProperties.type,
      detDate: geoProperties.detDate,
      imageDate: geoProperties.imageDate,
      specie: geoProperties.specie,
      latitude: geoProperties.latitude,
      longitude: geoProperties.longitude,
      points: geoProperties.points,
      name: geoProperties.name,
    );
  }

  GeolocationDataPropertiesModel copyWith({
    String? id,
    String? type,
    String? specie,
    String? geohash,
    DateTime? detDate,
    DateTime? imageDate,
    double? latitude,
    double? longitude,
    List<LatLng>? points,
    String? name,
  }) {
    return GeolocationDataPropertiesModel(
      id: id ?? this.id,
      geohash: geohash ?? this.geohash,
      type: type ?? this.type,
      specie: specie ?? this.specie,
      detDate: detDate ?? this.detDate,
      imageDate: imageDate ?? this.imageDate,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      points: points ?? this.points,
      name: name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'geohash': geohash,
      'type': type,
      'specie': specie,
      'detDate': detDate,
      'imageDate': imageDate,
      'latitude': latitude,
      'longitude': longitude,
      'points': points,
      'name': name,
    };
  }
}
