import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

class Catalog extends Equatable {
  final int id;
  final String name;
  final String scientificName;
  final List<String> images;
  final BitmapDescriptor icon;

  Catalog({
    @required this.id,
    @required this.name,
    @required this.scientificName,
    @required this.images,
    @required this.icon,
  });

  @override
  List<Object> get props => [id, name, scientificName, images, icon];
}
