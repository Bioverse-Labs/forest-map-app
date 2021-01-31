import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forestMapApp/core/errors/failure.dart';
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
    lat: faker.randomGenerator.decimal(),
    lng: faker.randomGenerator.decimal(),
    timestamp: faker.date.dateTime(),
  );
  Stream<Either<Failure, Location>> tStream() async* {
    yield (Right(tLocation));
  }

  test(
    'should return [Location] from stream when repository succeed',
    () async {
      when(mockLocationRepository.trackUserLocation()).thenAnswer(
        (_) async => Right(tStream()),
      );

      final result = await trackUser(NoParams());

      expect(
        result,
        isInstanceOf<Right<Failure, Stream<Either<Failure, Location>>>>(),
      );

      result.fold(
        (l) => null,
        (stream) => stream.listen(expectAsync1(
          (location) {
            expect(location, Right(tLocation));
          },
        )),
      );
      verify(mockLocationRepository.trackUserLocation());
      verifyNoMoreInteractions(mockLocationRepository);
    },
  );
}
