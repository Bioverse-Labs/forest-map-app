import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:forest_map_app/core/enums/exception_origin_types.dart';
import 'package:forest_map_app/core/errors/failure.dart';
import 'package:forest_map_app/core/usecases/usecase.dart';
import 'package:forest_map_app/features/tracking/domain/entities/location.dart';
import 'package:forest_map_app/features/tracking/domain/usecases/get_current_location.dart';
import 'package:forest_map_app/features/tracking/domain/usecases/get_locations.dart';
import 'package:forest_map_app/features/tracking/domain/usecases/save_location.dart';
import 'package:forest_map_app/features/tracking/domain/usecases/track_user.dart';
import 'package:forest_map_app/features/tracking/presentation/notifiers/location_notifier.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../core/notifiers/change_notifiers.dart';

class MockTrackUser extends Mock implements TrackUser {}

class MockGetCurrentLocation extends Mock implements GetCurrentLocation {}

class MockGetLocations extends Mock implements GetLocations {}

class MockSaveLocation extends Mock implements SaveLocation {}

void main() {
  MockTrackUser mockTrackUser;
  MockGetCurrentLocation mockGetCurrentLocation;
  MockGetLocations mockGetLocations;
  MockSaveLocation mockSaveLocation;
  LocationNotifierImpl locationNotifierImpl;

  setUp(() {
    mockTrackUser = MockTrackUser();
    mockGetCurrentLocation = MockGetCurrentLocation();
    mockGetLocations = MockGetLocations();
    mockSaveLocation = MockSaveLocation();
    locationNotifierImpl = LocationNotifierImpl(
      trackUserUseCase: mockTrackUser,
      getCurrentLocationUseCase: mockGetCurrentLocation,
      getLocationsUseCase: mockGetLocations,
      saveLocationUseCase: mockSaveLocation,
    );
  });

  final tUserId = faker.guid.guid();
  final tStream = StreamController<Location>().stream.asBroadcastStream();
  final tLocation = Location(
    id: faker.guid.guid(),
    lat: faker.randomGenerator.decimal(),
    lng: faker.randomGenerator.decimal(),
    timestamp: faker.date.dateTime(),
  );

  final tFailure = ServerFailure(
    faker.randomGenerator.string(20),
    faker.randomGenerator.string(4),
    ExceptionOriginTypes.test,
  );

  group('trackUser', () {
    test(
      'should set [Stream<Location> _trackStream] if usecase succeed',
      () async {
        when(mockTrackUser(any)).thenAnswer((_) async => Right(tStream));

        locationNotifierImpl.trackUser(tUserId);

        await expectToNotifiyListener<LocationNotifierImpl>(
          locationNotifierImpl,
          () => locationNotifierImpl.trackUser(tUserId),
          [
            NotifierAssertParams(
              value: (notifier) => notifier.stream,
              matcher: tStream,
            ),
          ],
        );

        verify(mockTrackUser(NoParams()));
        verifyNoMoreInteractions(mockTrackUser);
      },
    );

    test('should throw a [Failure] if usecase fails', () async {
      when(mockTrackUser(any)).thenAnswer((_) async => Left(tFailure));

      final call = locationNotifierImpl.trackUser;

      expect(
        () => call(tUserId),
        throwsA(isInstanceOf<ServerFailure>()),
      );

      verify(mockTrackUser(NoParams()));
      verifyNoMoreInteractions(mockTrackUser);
    });
  });

  group('getCurrentLocation', () {
    test(
      'should return [Location] if usecase succeed',
      () async {
        when(mockGetCurrentLocation(any)).thenAnswer(
          (_) async => Right(tLocation),
        );

        final result = await locationNotifierImpl.getCurrentLocation();

        expect(result, tLocation);
        verify(mockGetCurrentLocation(NoParams()));
        verifyNoMoreInteractions(mockTrackUser);
      },
    );

    test('should throw a [Failure] if usecase fails', () async {
      when(mockGetCurrentLocation(any)).thenAnswer((_) async => Left(tFailure));

      final call = locationNotifierImpl.getCurrentLocation;

      expect(
        () => call(),
        throwsA(isInstanceOf<ServerFailure>()),
      );

      verify(mockGetCurrentLocation(NoParams()));
      verifyNoMoreInteractions(mockTrackUser);
    });
  });
}
