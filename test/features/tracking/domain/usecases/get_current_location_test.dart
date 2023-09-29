import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forest_map/core/usecases/usecase.dart';
import 'package:forest_map/features/tracking/data/models/location_model.dart';
import 'package:forest_map/features/tracking/domain/repositories/location_repository.dart';
import 'package:forest_map/features/tracking/domain/usecases/get_current_location.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_current_location_test.mocks.dart';

@GenerateMocks([LocationRepository])
void main() {
  late MockLocationRepository mockLocationRepository;
  late GetCurrentLocation getCurrentLocation;

  setUp(() {
    mockLocationRepository = MockLocationRepository();
    getCurrentLocation = GetCurrentLocation(mockLocationRepository);
  });

  final tLocation = LocationModel(
    id: faker.guid.guid(),
    lat: faker.randomGenerator.decimal(),
    lng: faker.randomGenerator.decimal(),
    timestamp: DateTime.now(),
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
