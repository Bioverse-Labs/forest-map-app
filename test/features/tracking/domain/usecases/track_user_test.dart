import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forest_map_app/core/usecases/usecase.dart';
import 'package:forest_map_app/features/tracking/data/models/location_model.dart';
import 'package:forest_map_app/features/tracking/domain/entities/location.dart';
import 'package:forest_map_app/features/tracking/domain/repositories/location_repository.dart';
import 'package:forest_map_app/features/tracking/domain/usecases/track_user.dart';
import 'package:mockito/mockito.dart';

class MockLocationRepository extends Mock implements LocationRepository {}

void main() {
  MockLocationRepository mockLocationRepository;
  TrackUser trackUser;

  setUp(() {
    mockLocationRepository = MockLocationRepository();
    trackUser = TrackUser(mockLocationRepository);
  });

  final tLocation = LocationModel(
    id: faker.guid.guid(),
    lat: faker.randomGenerator.decimal(),
    lng: faker.randomGenerator.decimal(),
    timestamp: faker.date.dateTime(),
  );
  Stream<Location> tLocationStream() async* {
    yield tLocation;
  }

  test(
    'should return [Location] from stream when repository succeed',
    () async {
      when(mockLocationRepository.trackUserLocation()).thenAnswer(
        (_) async => Right(tLocationStream()),
      );
      when(mockLocationRepository.saveLocation(any, any))
          .thenAnswer((_) async => Right(tLocation));

      await trackUser(NoParams());

      verify(mockLocationRepository.trackUserLocation());
      tLocationStream().listen(expectAsync1(
        (event) {
          expect(event, tLocation);
        },
      ));
      verifyNoMoreInteractions(mockLocationRepository);
    },
  );
}
