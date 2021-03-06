import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forestMapApp/core/usecases/usecase.dart';
import 'package:forestMapApp/features/tracking/data/models/location_model.dart';
import 'package:forestMapApp/features/tracking/domain/repositories/location_repository.dart';
import 'package:forestMapApp/features/tracking/domain/usecases/get_current_location.dart';
import 'package:mockito/mockito.dart';

class MockLocationRepository extends Mock implements LocationRepository {}

void main() {
  MockLocationRepository mockLocationRepository;
  GetCurrentLocation getCurrentLocation;

  setUp(() {
    mockLocationRepository = MockLocationRepository();
    getCurrentLocation = GetCurrentLocation(mockLocationRepository);
  });

  final tLocation = LocationModel(
    id: faker.guid.guid(),
    lat: faker.randomGenerator.decimal(),
    lng: faker.randomGenerator.decimal(),
    timestamp: faker.date.dateTime(),
  );
  test(
    'should return [Location] from stream when repository succeed',
    () async {
      when(mockLocationRepository.getCurrentLocation())
          .thenAnswer((_) async => Right(tLocation));

      final result = await getCurrentLocation(NoParams());

      expect(result, Right(tLocation));
      verify(mockLocationRepository.getCurrentLocation());
      verifyNoMoreInteractions(mockLocationRepository);
    },
  );
}
