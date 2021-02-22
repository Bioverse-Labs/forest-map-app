import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class GeolocationDataProperties extends Equatable {
  final String id;
  final String type;
  final String specie;
  final DateTime detDate;
  final DateTime imageDate;
  final Polygon polygon;

  GeolocationDataProperties({
    @required this.id,
    @required this.type,
    @required this.specie,
    @required this.detDate,
    @required this.imageDate,
    @required this.polygon,
  });

  @override
  List<Object> get props => [id, type, specie, detDate, imageDate, polygon];
}
