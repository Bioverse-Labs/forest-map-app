import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:forestMapApp/core/enums/exception_origin_types.dart';
import 'package:forestMapApp/core/errors/failure.dart';
import 'package:forestMapApp/core/usecases/usecase.dart';
import 'package:forestMapApp/features/tracking/domain/entities/location.dart';
import 'package:forestMapApp/features/tracking/domain/usecases/get_current_location.dart';
import 'package:forestMapApp/features/tracking/domain/usecases/track_user.dart';
import 'package:forestMapApp/features/tracking/presentation/notifiers/location_notifier.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../core/notifiers/change_notifiers.dart';

class MockTrackUser extends Mock implements TrackUser {}

class MockGetCurrentLocation extends Mock implements GetCurrentLocation {}

void main() {
  MockTrackUser mockTrackUser;
  MockGetCurrentLocation mockGetCurrentLocation;
  LocationNotifierImpl locationNotifierImpl;

  setUp(() {
    mockTrackUser = MockTrackUser();
    mockGetCurrentLocation = MockGetCurrentLocation();
    locationNotifierImpl = LocationNotifierImpl(
      trackUserUseCase: mockTrackUser,
      getCurrentLocationUseCase: mockGetCurrentLocation,
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

        verify(mockTrackUser(TrackUserParams(tUserId)));
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

      verify(mockTrackUser(TrackUserParams(tUserId)));
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
