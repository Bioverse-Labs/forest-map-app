import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forest_map/features/tracking/data/hive/location.dart';
import 'package:forest_map/features/tracking/data/models/location_model.dart';
import 'package:forest_map/features/tracking/domain/entities/location.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  final tId = faker.guid.guid();
  final tLat = faker.randomGenerator.decimal();
  final tLng = faker.randomGenerator.decimal();
  final tTimestamp = DateTime.now();

  final tLocatioModel = LocationModel(
    id: tId,
    lat: tLat,
    lng: tLng,
    timestamp: tTimestamp,
  );

  final tLocationHive = LocationHive()
    ..id = tId
    ..lat = tLat
    ..lng = tLng
    ..timestamp = tTimestamp;

  test('should be subclass of Location entity', () async {
    expect(tLocatioModel, isA<Location>());
  });

  group('fromPosition', () {
    test('should return a valid model when the map is valid', () {
      final tPosition = Position(
        latitude: faker.randomGenerator.decimal(),
        longitude: faker.randomGenerator.decimal(),
        accuracy: faker.randomGenerator.decimal(),
        altitude: faker.randomGenerator.decimal(),
        floor: faker.randomGenerator.integer(10),
        heading: faker.randomGenerator.decimal(),
        isMocked: true,
        speed: faker.randomGenerator.decimal(),
        speedAccuracy: faker.randomGenerator.decimal(),
        timestamp: DateTime.now(),
      );

      final result = LocationModel.fromPosition(tPosition);
      expect(
        result.lat,
        tPosition.latitude,
      );
      expect(
        result.lng,
        tPosition.longitude,
      );
    });
  });

  group('copyWith', () {
    test(
      'should return a new instance of [LocationModel] with new data',
      () async {
        final result =
            tLocatioModel.copyWith(lat: faker.randomGenerator.decimal());
        expect(result, isNot(tLocatioModel));
      },
    );
  });

  group('fromHive', () {
    test(
      'should return [LocationModel] if [LocationHive] is valid',
      () async {
        final model = LocationModel.fromHive(tLocationHive);

        expect(model, isInstanceOf<LocationModel>());
      },
    );
  });
}
