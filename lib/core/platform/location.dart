import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

import '../errors/failure.dart';
import '../util/localized_string.dart';

abstract class LocationUtils {
  Future<Either<Failure, bool>> checkLocationPermission();
  Future<Either<Failure, Position>> getCurrentPosition(bool hasPermission);
  Future<Either<Failure, Position>> getLastKnowPosition(bool hasPermission);
  Future<bool> get isServiceEnabled;
}

class LocationUtilsImpl implements LocationUtils {
  final LocalizedString localizedString;

  LocationUtilsImpl(this.localizedString);

  @override
  Future<Either<Failure, Position>> getLastKnowPosition(
    bool hasPermission,
  ) async {
    try {
      final hasAccess = await checkLocationPermission();

      return hasAccess.fold(
        (failure) => Left(failure),
        (_) async {
          final position = await Geolocator.getLastKnownPosition(
            forceAndroidLocationManager: true,
          );
          return Right(position);
        },
      );
    } on PlatformException catch (err) {
      return Left(LocationFailure(err.message));
    } catch (err) {
      return Left(LocationFailure(err.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> checkLocationPermission() async {
    if (!await isServiceEnabled) {
      return Left(
        LocationFailure(localizedString.getLocalizedString(
          'location-permission.disabled',
        )),
      );
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.deniedForever) {
      return Left(
        LocationFailure(localizedString.getLocalizedString(
          'location-permission.denied-permantly',
        )),
      );
    }

    if (permission == LocationPermission.denied) {
      return Left(
        LocationFailure(localizedString.getLocalizedString(
          'location-permission.denied',
        )),
      );
    }

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      return Right(true);
    }

    return Right(false);
  }

  @override
  Future<Either<Failure, Position>> getCurrentPosition(
    bool hasPermission,
  ) async {
    try {
      final hasAccess = await checkLocationPermission();
      return hasAccess.fold(
        (failure) => Left(failure),
        (_) async {
          final position = await Geolocator.getCurrentPosition(
            forceAndroidLocationManager: true,
          );

          return Right(position);
        },
      );
    } on PlatformException catch (err) {
      return Left(LocationFailure(err.message));
    } catch (err) {
      return Left(LocationFailure(err.toString()));
    }
  }

  @override
  Future<bool> get isServiceEnabled => Geolocator.isLocationServiceEnabled();
}
