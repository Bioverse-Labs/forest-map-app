import 'package:hive/hive.dart';

import '../../../../core/adapters/hive_adapter.dart';
import '../../../../core/enums/exception_origin_types.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/platform/location.dart';
import '../../domain/entities/location.dart';
import '../hive/location.dart';
import '../models/location_model.dart';

abstract class LocationLocalDataSource {
  ///
  /// use [LocationUtils] to get stream with user location;
  ///
  Future<Stream<Location>> getPositionStream();

  ///
  /// save [Location] locally in [Hive]
  ///
  Future<void> saveLocation(
    String? userId,
    LocationModel location,
  );

  Future<List<LocationModel>> getLocations(String? userId);

  Future<void> syncLocations(String? userId, List<LocationModel> locations);

  Future<LocationModel> getCurrentLocation();
}

class LocationLocalDataSourceImpl implements LocationLocalDataSource {
  final LocationUtils? locationUtils;
  final HiveAdapter<LocationHive>? hiveAdapter;

  LocationLocalDataSourceImpl({
    required this.locationUtils,
    required this.hiveAdapter,
  });

  @override
  Future<Stream<Location>> getPositionStream() async {
    final hasPermission = await locationUtils!.checkLocationPermission();
    final stream = await locationUtils!.getLocationStream(hasPermission);

    return stream;
  }

  @override
  Future<void> saveLocation(
    String? userId,
    LocationModel location,
  ) async {
    try {
      await hiveAdapter!
          .put('$userId/${location.id}', location.toHiveAdapter());
    } on HiveError catch (error) {
      throw LocalException(
        error.message,
        error.message,
        ExceptionOriginTypes.hive,
        stackTrace: error.stackTrace,
      );
    }
  }

  @override
  Future<LocationModel> getCurrentLocation() async {
    final hasPermission = await locationUtils!.checkLocationPermission();
    return locationUtils!.getCurrentPosition(hasPermission)
        as Future<LocationModel>;
  }

  @override
  Future<List<LocationModel>> getLocations(userId) async {
    try {
      final keys = hiveAdapter!.getKeys();
      final locations = <LocationModel>[];

      for (var key in keys) {
        if ((key as String).contains(userId!)) {
          final hiveObject = (await hiveAdapter!.get(key))!;

          locations.add(LocationModel.fromHive(hiveObject));
        }
      }

      return locations;
    } on HiveError catch (error) {
      throw LocalException(
        error.message,
        error.message,
        ExceptionOriginTypes.hive,
        stackTrace: error.stackTrace,
      );
    }
  }

  @override
  Future<void> syncLocations(
    String? userId,
    List<LocationModel> locations,
  ) async {
    final keys = hiveAdapter!.getKeys();

    for (var location in locations) {
      final objectId = '$userId/${location.id}';
      final hasLocalCopy = keys.firstWhere(
        (key) => key == objectId,
        orElse: () => null,
      );

      if (hasLocalCopy != null) {
        await hiveAdapter!.delete(objectId);
      }

      await hiveAdapter!.put(objectId, location.toHiveAdapter());
    }
  }
}
