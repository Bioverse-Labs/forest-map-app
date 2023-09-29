import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forest_map/features/tracking/data/models/location_model.dart';
import 'package:forest_map/features/tracking/domain/repositories/location_repository.dart';
import 'package:forest_map/features/tracking/domain/usecases/get_locations.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_locations_test.mocks.dart';

@GenerateMocks([LocationRepository])
void main() {
  late MockLocationRepository mockLocationRepository;
  late GetLocations getLocations;

  setUp(() {
    mockLocationRepository = MockLocationRepository();
    getLocations = GetLocations(mockLocationRepository);
  });

  final tLocation = LocationModel(
    id: faker.guid.guid(),
    lat: faker.randomGenerator.decimal(),
    lng: faker.randomGenerator.decimal(),
    timestamp: DateTime.now(),
  );
  test(
    'should return [Locations] from stream when repository succeed',
    () async {
      when(mockLocationRepository.getLocations(any))
          .thenAnswer((_) async => Right([tLocation]));

      final result = await getLocations(GetLocationsParams(faker.guid.guid()));

      result.fold((l) => null, (r) => expect(r, [tLocation]));
      verify(mockLocationRepository.getLocations(any));
      verifyNoMoreInteractions(mockLocationRepository);
    },
  );
}
