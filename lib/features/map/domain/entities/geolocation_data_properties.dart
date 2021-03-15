import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class GeolocationDataProperties extends Equatable {
  final String id;
  final String type;
  final String specie;
  final DateTime detDate;
  final DateTime imageDate;
  final double latitude;
  final double longitude;

  GeolocationDataProperties({
    @required this.id,
    @required this.type,
    @required this.specie,
    @required this.detDate,
    @required this.imageDate,
    @required this.latitude,
    @required this.longitude,
  });

  @override
  List<Object> get props => [
        id,
        type,
        specie,
        detDate,
        imageDate,
        latitude,
        longitude,
      ];
}
