import 'package:flutter/services.dart';
import 'package:forestMapApp/utils/notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:easy_localization/easy_localization.dart';

class LocationUtils {
  static Future<bool> checkLocationPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('location-permission.disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      throw Exception('location-permission.denied-permantly');
    }

    if (permission == LocationPermission.denied) {
      throw Exception('location-permission.denied'.tr());
    }

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      return true;
    }

    return false;
  }

  static Future<Position> getCurrentPosition() async {
    try {
      final hasAccess = await checkLocationPermission();
      if (hasAccess) {
        return Geolocator.getCurrentPosition(forceAndroidLocationManager: true);
      }
    } on PlatformException catch (err) {
      Notifications.showErrorNotification(err.message);
    } catch (err) {
      Notifications.showErrorNotification(err);
    }

    return null;
  }

  static Future<Position> getLastKnowLocation() async {
    try {
      final hasAccess = await checkLocationPermission();
      if (hasAccess) {
        return Geolocator.getLastKnownPosition(
          forceAndroidLocationManager: true,
        );
      }
    } on PlatformException catch (err) {
      Notifications.showErrorNotification(err.message);
    } catch (err) {
      Notifications.showErrorNotification(err);
    }

    return null;
  }
}
