import 'dart:async';

import 'package:flutter/foundation.dart';
import '../../domain/usecases/get_locations.dart';
import '../../domain/usecases/save_location.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/location.dart';
import '../../domain/usecases/get_current_location.dart';
import '../../domain/usecases/track_user.dart';

abstract class LocationNotifier {
  Future<void> trackUser(String userId);
  Future<Location> getCurrentLocation();
  Future<void> getLocations(String userId);
}

class LocationNotifierImpl extends ChangeNotifier implements LocationNotifier {
  final TrackUser trackUserUseCase;
  final GetCurrentLocation getCurrentLocationUseCase;
  final SaveLocation saveLocationUseCase;
  final GetLocations getLocationsUseCase;

  StreamSubscription<Location> _streamSubscription;
  Location _location;
  List<Location> _locations = [];
  bool _loading = false;

  LocationNotifierImpl({
    @required this.trackUserUseCase,
    @required this.getCurrentLocationUseCase,
    @required this.saveLocationUseCase,
    @required this.getLocationsUseCase,
  });

  StreamSubscription<Location> get stream => _streamSubscription;
  Location get currentLocation => _location;
  List<Location> get locationHistory => _locations;
  bool get isLoading => _loading;

  Future<void> trackUser(String userId) async {
    final failureOrStream = await trackUserUseCase(NoParams());

    failureOrStream.fold(
      (failure) => throw failure,
      (stream) {
        _streamSubscription = stream.listen((location) async {
          _location = location;
          notifyListeners();

          final res = await saveLocationUseCase(SaveLocationParams(
            userId: userId,
            location: location,
          ));

          res.fold(
            (failure) => throw Future.error(failure),
            (_) => getLocations(userId),
          );
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

  @override
  Future<void> getLocations(String userId) async {
    _loading = true;
    notifyListeners();

    final failureOrLocations =
        await getLocationsUseCase(GetLocationsParams(userId));

    _loading = false;
    notifyListeners();

    return failureOrLocations.fold(
      (failure) => throw Future.error(failure),
      (locations) {
        _locations = locations;
        notifyListeners();
      },
    );
  }
}
