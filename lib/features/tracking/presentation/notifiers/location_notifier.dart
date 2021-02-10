import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:forestMapApp/core/usecases/usecase.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/location.dart';
import '../../domain/usecases/get_current_location.dart';
import '../../domain/usecases/track_user.dart';

abstract class LocationNotifier {
  Future<void> trackUser(String userId);
  Future<Location> getCurrentLocation();
}

class LocationNotifierImpl extends ChangeNotifier implements LocationNotifier {
  final TrackUser trackUserUseCase;
  final GetCurrentLocation getCurrentLocationUseCase;

  Stream<Location> _streamSubscription;
  Location _location;

  LocationNotifierImpl({
    @required this.trackUserUseCase,
    @required this.getCurrentLocationUseCase,
  });

  Stream<Location> get stream => _streamSubscription;
  Location get currentLocation => _location;

  Future<void> trackUser(String userId) async {
    final failureOrStream = await trackUserUseCase(TrackUserParams(userId));

    failureOrStream.fold(
      (failure) => throw failure,
      (subscription) {
        _streamSubscription = subscription;
        _streamSubscription.listen((event) {
          _location = event;
          notifyListeners();
        });
        notifyListeners();
      },
    );
  }

  @override
  Future<Location> getCurrentLocation() async {
    final failureOrLocation = await getCurrentLocationUseCase(NoParams());

    return failureOrLocation.fold(
      (failure) => throw failure,
      (location) => location,
    );
  }
}
