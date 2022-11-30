import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

import '../../features/tracking/data/models/location_model.dart';
import '../../features/tracking/domain/entities/location.dart';
import '../enums/exception_origin_types.dart';
import '../errors/exceptions.dart';
import '../util/localized_string.dart';

abstract class LocationUtils {
  Future<bool> checkLocationPermission();
  Future<Location> getCurrentPosition(bool hasPermission);
  Future<Location> getLastKnowPosition(bool hasPermission);
  Future<Stream<Location>> getLocationStream(bool hasPermission);
  Future<bool> get isServiceEnabled;
}

class LocationUtilsImpl implements LocationUtils {
  final LocalizedString localizedString;
  final LocationSource locationSource;

  LocationUtilsImpl(this.localizedString, this.locationSource);

  @override
  Future<LocationModel> getLastKnowPosition(
    bool hasPermission,
  ) async {
    try {
      if (hasPermission) {
        final position = await locationSource.getLastKnowPosition();

        return LocationModel.fromPosition(position);
      }

      throw LocalException(
        'no permission',
        '403',
        ExceptionOriginTypes.platform,
      );
    } on PlatformException catch (error) {
      throw LocalException(
        error.message,
        error.code,
        ExceptionOriginTypes.platform,
        stackTrace: StackTrace.fromString(error.stacktrace),
      );
    }
  }

  @override
  Future<bool> checkLocationPermission() async {
    try {
      if (!await isServiceEnabled) {
        throw LocationException(
          localizedString.getLocalizedString(
            'location-permission.disabled',
          ),
          false,
          false,
        );
      }

      LocationPermission permission = await locationSource.getPermission();

      if (permission == LocationPermission.deniedForever) {
        throw LocationException(
          localizedString.getLocalizedString(
            'location-permission.denied-permantly',
          ),
          false,
          true,
        );
      }

      if (permission == LocationPermission.denied) {
        throw LocationException(
          localizedString.getLocalizedString(
            'location-permission.denied',
          ),
          false,
          true,
        );
      }

      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        return true;
      }

      return true;
    } on PlatformException catch (error) {
      throw LocalException(
        error.message,
        error.code,
        ExceptionOriginTypes.platform,
        stackTrace: StackTrace.fromString(error.stacktrace),
      );
    }
  }

  @override
  Future<LocationModel> getCurrentPosition(
    bool hasPermission,
  ) async {
    try {
      if (hasPermission) {
        final position = await locationSource.getCurrentPosition();

        return LocationModel.fromPosition(position);
      }

      throw LocalException(
        'no permission',
        '403',
        ExceptionOriginTypes.platform,
      );
    } on PlatformException catch (error) {
      throw LocalException(
        error.message,
        error.code,
        ExceptionOriginTypes.platform,
        stackTrace: StackTrace.fromString(error.stacktrace),
      );
    }
  }

  @override
  Future<bool> get isServiceEnabled => locationSource.isLocationServiceEnabled;

  @override
  Future<Stream<Location>> getLocationStream(bool hasPermission) async {
    try {
      if (hasPermission) {
        final stream = locationSource.getPositionStream();
        return Future.value(
          stream.expand((element) => [LocationModel.fromPosition(element)]),
        );
      }

      throw LocalException(
        'no permission',
        '403',
        ExceptionOriginTypes.platform,
      );
    } on PlatformException catch (error) {
      throw LocalException(
        error.message,
        error.code,
        ExceptionOriginTypes.platform,
        stackTrace: StackTrace.fromString(error.stacktrace),
      );
    }
  }
}

class LocationSource {
  Future<LocationPermission> getPermission() => Geolocator.requestPermission();

  Future<LocationPermission> checkPermission() => Geolocator.checkPermission();

  Future<Position> getCurrentPosition() => Geolocator.getCurrentPosition();

  Future<Position> getLastKnowPosition() => Geolocator.getLastKnownPosition();

  Stream<Position> getPositionStream() =>
      Geolocator.getPositionStream(distanceFilter: 100);

  Future<bool> get isLocationServiceEnabled =>
      Geolocator.isLocationServiceEnabled();
}
