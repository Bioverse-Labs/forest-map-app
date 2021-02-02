import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forestMapApp/features/tracking/data/models/location_model.dart';
import 'package:forestMapApp/features/tracking/domain/entities/location.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  final tId = faker.guid.guid();
  final tLat = faker.randomGenerator.decimal();
  final tLng = faker.randomGenerator.decimal();
  final tTimestamp = faker.date.dateTime();

  final tLocatioModel = LocationModel(
    id: tId,
    lat: tLat,
    lng: tLng,
    timestamp: tTimestamp,
  );

  test('should be subclass of Location entity', () async {
    expect(tLocatioModel, isA<Location>());
  });

  group('fromPosition', () {
    test('should return a valid model when the map is valid', () {
      final tPosition = Position(
        latitude: tLat,
        longitude: tLng,
        timestamp: tTimestamp,
      );

      final result = LocationModel.fromPosition(tPosition);
      expect(result, tLocatioModel);
    });
  });
}
