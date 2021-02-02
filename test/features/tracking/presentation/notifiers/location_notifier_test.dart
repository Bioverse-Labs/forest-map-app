import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:forestMapApp/core/enums/exception_origin_types.dart';
import 'package:forestMapApp/core/errors/failure.dart';
import 'package:forestMapApp/features/tracking/domain/entities/location.dart';
import 'package:forestMapApp/features/tracking/domain/usecases/track_user.dart';
import 'package:forestMapApp/features/tracking/presentation/notifiers/location_notifier.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../core/notifiers/change_notifiers.dart';

class MockTrackUser extends Mock implements TrackUser {}

void main() {
  MockTrackUser mockTrackUser;
  LocationNotifierImpl locationNotifierImpl;

  setUp(() {
    mockTrackUser = MockTrackUser();
    locationNotifierImpl = LocationNotifierImpl(mockTrackUser);
  });

  final tUserId = faker.guid.guid();
  final tStream = StreamController<Location>()
      .stream
      .asBroadcastStream()
      .listen((event) {});

  final tFailure = ServerFailure(
    faker.randomGenerator.string(20),
    faker.randomGenerator.string(4),
    ExceptionOriginTypes.test,
  );

  test(
    'should set [Stream<Location> _trackStream] if usecase succeed',
    () async {
      when(mockTrackUser(any)).thenAnswer((_) async => Right(tStream));

      locationNotifierImpl.startTracking(tUserId);

      await expectToNotifiyListener<LocationNotifierImpl>(
        locationNotifierImpl,
        () => locationNotifierImpl.startTracking(tUserId),
        [
          NotifierAssertParams(
            value: (notifier) => notifier.stream,
            matcher: tStream,
          ),
        ],
      );

      verify(mockTrackUser(TrackUserParams(tUserId)));
      verifyNoMoreInteractions(mockTrackUser);
      tStream.cancel();
    },
  );

  test('should throw a [Failure] if usecase fails', () async {
    when(mockTrackUser(any)).thenAnswer((_) async => Left(tFailure));

    final call = locationNotifierImpl.startTracking;

    expect(
      () => call(tUserId),
      throwsA(isInstanceOf<ServerFailure>()),
    );

    verify(mockTrackUser(TrackUserParams(tUserId)));
    verifyNoMoreInteractions(mockTrackUser);
  });
}
