import 'package:geolocator/geolocator.dart';

import '../../domain/entities/location.dart';
import '../models/location_model.dart';

abstract class LocationLocalDataSource {
  ///
  /// use [LocationUtils] to get stream with user location;
  ///
  Future<Stream<Position>> getPositionStream();

  ///
  /// save [Location] locally in [Hive]
  ///
  Future<LocationModel> saveLocation(Map<String, dynamic> map);
}

class LocationLocalDataSourceImpl implements LocationLocalDataSource {
  @override
  Future<Stream<Position>> getPositionStream() {
    // TODO: implement getPositionStream
    throw UnimplementedError();
  }

  @override
  Future<LocationModel> saveLocation(Map<String, dynamic> map) {
    // TODO: implement saveLocation
    throw UnimplementedError();
  }
}
