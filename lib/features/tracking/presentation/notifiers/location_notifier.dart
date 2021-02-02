import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../domain/entities/location.dart';
import '../../domain/usecases/track_user.dart';

abstract class LocationNotifier {
  Future<void> startTracking(String userId);
}

class LocationNotifierImpl extends ChangeNotifier implements LocationNotifier {
  final TrackUser trackUser;

  StreamSubscription<Location> _streamSubscription;

  LocationNotifierImpl(this.trackUser);

  StreamSubscription<Location> get stream => _streamSubscription;

  Future<void> startTracking(String userId) async {
    final failureOrStream = await trackUser(TrackUserParams(userId));

    failureOrStream.fold(
      (failure) => throw failure,
      (subscription) {
        _streamSubscription = subscription;
        notifyListeners();
      },
    );
  }
}
