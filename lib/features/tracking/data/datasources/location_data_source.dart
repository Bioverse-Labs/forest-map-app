import 'package:meta/meta.dart';

import '../../../../core/adapters/firestore_adapter.dart';
import '../../../../core/platform/location.dart';
import '../../domain/entities/location.dart';
import '../models/location_model.dart';

abstract class LocationDataSource {
  ///
  /// use [LocationUtils] to get stream with user location;
  ///
  Future<Stream<Location>> getPositionStream();

  ///
  /// save [Location] locally in [Hive]
  ///
  Future<LocationModel> saveLocation(
    String userId,
    Map<String, dynamic> payload,
  );
}

class LocationDataSourceImpl implements LocationDataSource {
  final LocationUtilsImpl locationUtils;
  final FirestoreAdapterImpl firestoreAdapter;

  LocationDataSourceImpl({
    @required this.locationUtils,
    @required this.firestoreAdapter,
  });

  @override
  Future<Stream<Location>> getPositionStream() async {
    final hasPermission = await locationUtils.checkLocationPermission();
    return locationUtils.getLocationStream(hasPermission);
  }

  @override
  Future<LocationModel> saveLocation(
    String userId,
    Map<String, dynamic> payload,
  ) async {
    await firestoreAdapter.addDocument(
      'users/$userId/tracking/${payload['id']}',
      payload,
    );
    return LocationModel.fromMap(payload);
  }
}
