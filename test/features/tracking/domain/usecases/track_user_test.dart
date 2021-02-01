import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forestMapApp/core/usecases/usecase.dart';
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

  final tLocation = Location(
    id: faker.guid.guid(),
    lat: faker.randomGenerator.decimal(),
    lng: faker.randomGenerator.decimal(),
    timestamp: faker.date.dateTime(),
  );

  Stream<Location> tStream() async* {
    yield tLocation;
  }

  test(
    'should return [Location] from stream when repository succeed',
    () async {
      when(mockLocationRepository.trackUserLocation()).thenAnswer(
        (_) async => Right(tStream()),
      );

      final result = await trackUser(NoParams());

      result.fold(
        (l) => null,
        (stream) => stream.listen(expectAsync1(
          (location) {
            expect(location, tLocation);
          },
        )),
      );
      verify(mockLocationRepository.trackUserLocation());
      verifyNoMoreInteractions(mockLocationRepository);
    },
  );
}
