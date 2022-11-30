import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

class GeolocationDataProperties extends Equatable {
  final String id;
  final String geohash;
  final String type;
  final String specie;
  final String name;
  final DateTime detDate;
  final DateTime imageDate;
  final double latitude;
  final double longitude;
  final List<LatLng> points;

  GeolocationDataProperties({
    @required this.id,
    @required this.geohash,
    @required this.type,
    @required this.specie,
    @required this.detDate,
    @required this.imageDate,
    @required this.latitude,
    @required this.longitude,
    this.name = '',
    this.points = const <LatLng>[],
  });

  @override
  List<Object> get props => [
        id,
        geohash,
        type,
        specie,
        detDate,
        imageDate,
        latitude,
        longitude,
        name,
        points,
      ];
}
