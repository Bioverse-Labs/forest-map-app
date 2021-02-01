import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

import '../enums/exception_origin_types.dart';
import '../errors/exceptions.dart';
import '../util/localized_string.dart';

abstract class LocationUtils {
  Future<bool> checkLocationPermission();
  Future<Position> getCurrentPosition(bool hasPermission);
  Future<Position> getLastKnowPosition(bool hasPermission);
  Future<bool> get isServiceEnabled;
}

class LocationUtilsImpl implements LocationUtils {
  final LocalizedString localizedString;

  LocationUtilsImpl(this.localizedString);

  @override
  Future<Position> getLastKnowPosition(
    bool hasPermission,
  ) async {
    try {
      final hasAccess = await checkLocationPermission();

      if (hasAccess) {
        final position = await Geolocator.getLastKnownPosition(
          forceAndroidLocationManager: true,
        );
        return position;
      }

      return null;
    } on PlatformException catch (error) {
      throw LocalException(
        error.message,
        error.code,
        ExceptionOriginTypes.platform,
        stackTrace: StackTrace.fromString(error.stacktrace),
      );
    } catch (error) {
      throw LocalException(
        error?.toString(),
        error?.code,
        ExceptionOriginTypes.platform,
        stackTrace: StackTrace.fromString(error?.stacktrace),
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

      LocationPermission permission = await Geolocator.checkPermission();

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
    } catch (error) {
      throw LocalException(
        error?.toString(),
        error?.code,
        ExceptionOriginTypes.platform,
        stackTrace: StackTrace.fromString(error?.stacktrace),
      );
    }
  }

  @override
  Future<Position> getCurrentPosition(
    bool hasPermission,
  ) async {
    try {
      final hasAccess = await checkLocationPermission();
      if (hasAccess) {
        final position = await Geolocator.getCurrentPosition(
          forceAndroidLocationManager: true,
        );

        return position;
      }

      return null;
    } on PlatformException catch (error) {
      throw LocalException(
        error.message,
        error.code,
        ExceptionOriginTypes.platform,
        stackTrace: StackTrace.fromString(error.stacktrace),
      );
    } catch (error) {
      throw LocalException(
        error?.toString(),
        error?.code,
        ExceptionOriginTypes.platform,
        stackTrace: StackTrace.fromString(error?.stacktrace),
      );
    }
  }

  @override
  Future<bool> get isServiceEnabled => Geolocator.isLocationServiceEnabled();
}
