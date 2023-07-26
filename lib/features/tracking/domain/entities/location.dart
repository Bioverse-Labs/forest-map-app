import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final String? id;
  final double? lat;
  final double? lng;
  final DateTime? timestamp;
  final double? altitude;
  final double? accuracy;
  final double? heading;
  final int? floor;
  final double? speed;
  final double? speedAccuracy;

  Location({
    required this.id,
    required this.lat,
    required this.lng,
    required this.timestamp,
    this.altitude,
    this.accuracy,
    this.heading,
    this.floor,
    this.speed,
    this.speedAccuracy,
  });

  @override
  List<Object?> get props => [
        lat,
        lng,
        timestamp,
        altitude,
        accuracy,
        heading,
        floor,
        speed,
        speedAccuracy,
      ];
}
