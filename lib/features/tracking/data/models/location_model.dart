import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/location.dart';

class LocationModel extends Location {
  final String id;
  final double lat;
  final double lng;
  final DateTime timestamp;
  final double altitude;
  final double accuracy;
  final double heading;
  final int floor;
  final double speed;
  final double speedAccuracy;

  LocationModel({
    @required this.id,
    @required this.lat,
    @required this.lng,
    @required this.timestamp,
    this.altitude,
    this.accuracy,
    this.heading,
    this.floor,
    this.speed,
    this.speedAccuracy,
  });

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
}
