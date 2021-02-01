import '../../domain/entities/location.dart';
import '../models/location_model.dart';

abstract class LocationRemoteDataSource {
  ///
  /// save [Location] locally in [User] sub collection [Tracking]
  ///
  Future<LocationModel> saveLocation(Map<String, dynamic> map);
}

class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  @override
  Future<LocationModel> saveLocation(Map<String, dynamic> map) {
    // TODO: implement saveLocation
    throw UnimplementedError();
  }
}
