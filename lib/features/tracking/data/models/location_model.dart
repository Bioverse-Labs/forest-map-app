import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/models/model.dart';
import '../../domain/entities/location.dart';
import '../hive/location.dart';

class LocationModel extends Location
    implements Model<LocationModel, LocationHive> {
  LocationModel({
    @required String id,
    @required double lat,
    @required double lng,
    @required DateTime timestamp,
    double altitude,
    double accuracy,
    double heading,
    int floor,
    double speed,
    double speedAccuracy,
  }) : super(
          id: id,
          lat: lat,
          lng: lng,
          timestamp: timestamp,
          altitude: altitude,
          accuracy: accuracy,
          heading: heading,
          floor: floor,
          speed: speed,
          speedAccuracy: speedAccuracy,
        );

  factory LocationModel.fromPosition(Position position) {
    assert(position != null);

    return LocationModel(
      id: Uuid().v4(),
      lat: position.latitude,
      lng: position.longitude,
      timestamp: position.timestamp,
      accuracy: position.accuracy,
      altitude: position.altitude,
      floor: position.floor,
      heading: position.heading,
      speed: position.speed,
      speedAccuracy: position.speedAccuracy,
    );
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    assert(map != null);

    return LocationModel(
      id: map['id'],
      lat: (map['lat'] as num),
      lng: (map['lng'] as num),
      timestamp: map['timestamp'] as DateTime,
      accuracy: (map['accuracy'] as num),
      altitude: (map['altitude'] as num),
      floor: (map['floor'] as num),
      heading: (map['heading'] as num),
      speed: (map['speed'] as num),
      speedAccuracy: (map['speedAccuracy'] as num),
    );
  }

  factory LocationModel.fromHive(LocationHive locationHive) {
    return LocationModel(
      id: locationHive.id,
      lat: locationHive.lat,
      lng: locationHive.lng,
      timestamp: locationHive.timestamp,
      altitude: locationHive.altitude,
      accuracy: locationHive.accuracy,
      heading: locationHive.heading,
      floor: locationHive.floor,
      speed: locationHive.speed,
      speedAccuracy: locationHive.speedAccuracy,
    );
  }

  factory LocationModel.fromEntity(Location location) {
    return LocationModel(
      id: location.id,
      lat: location.lat,
      lng: location.lng,
      timestamp: location.timestamp,
      altitude: location.altitude,
      accuracy: location.accuracy,
      heading: location.heading,
      floor: location.floor,
      speed: location.speed,
      speedAccuracy: location.speedAccuracy,
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'lat': lat,
        'lng': lng,
        'timestamp': timestamp,
        'accuracy': accuracy,
        'altitude': altitude,
        'floor': floor,
        'heading': heading,
        'speed': speed,
        'speedAccuracy': speedAccuracy,
      };

  @override
  LocationModel copyWith({
    String id,
    double lat,
    double lng,
    DateTime timestamp,
    double altitude,
    double accuracy,
    double heading,
    int floor,
    double speed,
    double ccuracy,
  }) {
    return LocationModel(
      id: id ?? this.id,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      timestamp: timestamp ?? this.timestamp,
      altitude: altitude ?? this.altitude,
      accuracy: accuracy ?? this.accuracy,
      heading: heading ?? this.heading,
      floor: floor ?? this.floor,
      speed: speed ?? this.speed,
      speedAccuracy: speedAccuracy ?? this.speedAccuracy,
    );
  }

  @override
  LocationHive toHiveAdapter() {
    return LocationHive()
      ..id = id
      ..lat = lat
      ..lng = lng
      ..timestamp = timestamp
      ..altitude = altitude
      ..accuracy = accuracy
      ..heading = heading
      ..floor = floor
      ..speed = speed
      ..speedAccuracy = speedAccuracy;
  }
}
