import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forestMapApp/features/tracking/domain/entities/location.dart';
import 'package:forestMapApp/features/tracking/domain/repositories/location_repository.dart';
import 'package:forestMapApp/features/tracking/domain/usecases/track_user.dart';
import 'package:mockito/mockito.dart';

class MockLocationRepository extends Mock implements LocationRepository {}

void main() {
  MockLocationRepository mockLocationRepository;
  TrackUser trackUser;

  setUp(() {
    mockLocationRepository = MockLocationRepository();
    trackUser = TrackUser(mockLocationRepository);
  });

  final tUserId = faker.guid.guid();
  final tLocationStream = StreamController<Location>();

  test(
    'should return [Location] from stream when repository succeed',
    () async {
      when(mockLocationRepository.trackUserLocation()).thenAnswer(
        (_) async => Right(tLocationStream.stream),
      );

      await trackUser(TrackUserParams(tUserId));

      verify(mockLocationRepository.trackUserLocation());
      verifyNoMoreInteractions(mockLocationRepository);
      tLocationStream.close();
    },
  );
}
