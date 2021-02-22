import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'geolocation_data_properties.dart';

class GeolocationData extends Equatable {
  final String name;
  final List<GeolocationDataProperties> dataProperties;

  GeolocationData({@required this.name, @required this.dataProperties});

  @override
  List<Object> get props => [name, dataProperties];
}
