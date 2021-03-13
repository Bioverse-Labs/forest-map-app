import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forest_map_app/core/errors/exceptions.dart';
import 'package:forest_map_app/core/platform/location.dart';
import 'package:forest_map_app/core/util/localized_string.dart';
import 'package:forest_map_app/features/tracking/domain/entities/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/mockito.dart';

class MockLocationSource extends Mock implements LocationSource {}

class MockLocalizedString extends Mock implements LocalizedString {}

void main() {
  MockLocationSource mockLocationSource;
  MockLocalizedString mockLocalizedString;
  LocationUtilsImpl locationUtilsImpl;

  setUp(() {
    mockLocationSource = MockLocationSource();
    mockLocalizedString = MockLocalizedString();
    locationUtilsImpl = LocationUtilsImpl(
      mockLocalizedString,
      mockLocationSource,
    );
  });

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

  group('getLastKnowPosition', () {
    test(
      'should return [Location] if source succeed',
      () async {
        when(mockLocationSource.getLastKnowPosition())
            .thenAnswer((_) async => tPosition);

        final result = await locationUtilsImpl.getLastKnowPosition(true);

        expect(result, isInstanceOf<Location>());
        verify(mockLocationSource.getLastKnowPosition());
        verifyNoMoreInteractions(mockLocationSource);
      },
    );

    test(
      'should throw [LocalException] if permission is false',
      () async {
        final call = locationUtilsImpl.getLastKnowPosition;
        expect(() => call(false), throwsA(isInstanceOf<LocalException>()));
        verifyZeroInteractions(mockLocationSource);
      },
    );

    test(
      'should throw [LocalException] location fails',
      () async {
        when(mockLocationSource.getLastKnowPosition()).thenThrow(
          PlatformException(code: faker.randomGenerator.string(20)),
        );

        final call = locationUtilsImpl.getLastKnowPosition;

        expect(() => call(true), throwsA(isInstanceOf<LocalException>()));
        verify(mockLocationSource.getLastKnowPosition());
        verifyNoMoreInteractions(mockLocationSource);
      },
    );
  });

  group('getCurrentPosition', () {
    test(
      'should return [Location] if source succeed',
      () async {
        when(mockLocationSource.getCurrentPosition())
            .thenAnswer((_) async => tPosition);

        final result = await locationUtilsImpl.getCurrentPosition(true);

        expect(result, isInstanceOf<Location>());
        verify(mockLocationSource.getCurrentPosition());
        verifyNoMoreInteractions(mockLocationSource);
      },
    );

    test(
      'should throw [LocalException] if permission is false',
      () async {
        final call = locationUtilsImpl.getCurrentPosition;
        expect(() => call(false), throwsA(isInstanceOf<LocalException>()));
        verifyZeroInteractions(mockLocationSource);
      },
    );

    test(
      'should throw [LocalException] location fails',
      () async {
        when(mockLocationSource.getCurrentPosition()).thenThrow(
          PlatformException(code: faker.randomGenerator.string(20)),
        );

        final call = locationUtilsImpl.getCurrentPosition;

        expect(() => call(true), throwsA(isInstanceOf<LocalException>()));
        verify(mockLocationSource.getCurrentPosition());
        verifyNoMoreInteractions(mockLocationSource);
      },
    );
  });

  group('getStream', () {
    final tStream = StreamController<Position>();
    test(
      'should return [Stream] if source succeed',
      () async {
        when(mockLocationSource.getPositionStream())
            .thenAnswer((_) => tStream.stream);

        final result = await locationUtilsImpl.getLocationStream(true);

        expect(result, isInstanceOf<Stream<Location>>());
        verify(mockLocationSource.getPositionStream());
        verifyNoMoreInteractions(mockLocationSource);
        tStream.close();
      },
    );

    test(
      'should throw [LocalException] if permission is false',
      () async {
        final call = locationUtilsImpl.getLocationStream;
        expect(() => call(false), throwsA(isInstanceOf<LocalException>()));
        verifyZeroInteractions(mockLocationSource);
      },
    );

    test(
      'should throw [LocalException] location fails',
      () async {
        when(mockLocationSource.getPositionStream()).thenThrow(
          PlatformException(code: faker.randomGenerator.string(20)),
        );

        final call = locationUtilsImpl.getLocationStream;

        expect(() => call(true), throwsA(isInstanceOf<LocalException>()));
        verify(mockLocationSource.getPositionStream());
        verifyNoMoreInteractions(mockLocationSource);
      },
    );
  });

  group('checkLocationPermission', () {
    test(
      'should return [true] if permission is granted',
      () async {
        when(mockLocationSource.isLocationServiceEnabled)
            .thenAnswer((_) async => true);
        when(mockLocationSource.getPermission())
            .thenAnswer((_) async => LocationPermission.always);

        final result = await locationUtilsImpl.checkLocationPermission();

        expect(result, true);
        verify(mockLocationSource.isLocationServiceEnabled);
        verify(mockLocationSource.getPermission());
        verifyNoMoreInteractions(mockLocationSource);
      },
    );

    test(
      'should return [true] if permission is granted',
      () async {
        when(mockLocationSource.isLocationServiceEnabled)
            .thenAnswer((_) async => true);
        when(mockLocationSource.getPermission())
            .thenAnswer((_) async => LocationPermission.whileInUse);

        final result = await locationUtilsImpl.checkLocationPermission();

        expect(result, true);
        verify(mockLocationSource.isLocationServiceEnabled);
        verify(mockLocationSource.getPermission());
        verifyNoMoreInteractions(mockLocationSource);
      },
    );

    test(
      'should throw [LocationException] if service is not enabled',
      () async {
        when(mockLocationSource.isLocationServiceEnabled)
            .thenAnswer((_) async => false);

        final call = locationUtilsImpl.checkLocationPermission;

        expect(() => call(), throwsA(isInstanceOf<LocationException>()));
        verify(mockLocationSource.isLocationServiceEnabled);
        verifyNoMoreInteractions(mockLocationSource);
      },
    );

    test(
      'should throw [LocationException] if permission is not granted',
      () async {
        when(mockLocationSource.isLocationServiceEnabled)
            .thenAnswer((_) async => true);
        when(mockLocationSource.getPermission())
            .thenAnswer((_) async => LocationPermission.denied);

        try {
          await locationUtilsImpl.checkLocationPermission();
        } catch (error) {
          expect(error, isInstanceOf<LocationException>());
        }

        verify(mockLocationSource.isLocationServiceEnabled);
        verify(mockLocationSource.getPermission());
        verifyNoMoreInteractions(mockLocationSource);
      },
    );

    test(
      'should throw [LocationException] if permission is denied forever',
      () async {
        when(mockLocationSource.isLocationServiceEnabled)
            .thenAnswer((_) async => true);
        when(mockLocationSource.getPermission())
            .thenAnswer((_) async => LocationPermission.deniedForever);

        try {
          await locationUtilsImpl.checkLocationPermission();
        } catch (error) {
          expect(error, isInstanceOf<LocationException>());
        }

        verify(mockLocationSource.isLocationServiceEnabled);
        verify(mockLocationSource.getPermission());
        verifyNoMoreInteractions(mockLocationSource);
      },
    );

    test(
      'should throw [LocalException] location fails',
      () async {
        when(mockLocationSource.isLocationServiceEnabled)
            .thenAnswer((_) async => true);
        when(mockLocationSource.getPermission()).thenThrow(
          PlatformException(code: faker.randomGenerator.string(20)),
        );

        try {
          await locationUtilsImpl.checkLocationPermission();
        } catch (error) {
          expect(error, isInstanceOf<LocalException>());
        }

        verify(mockLocationSource.isLocationServiceEnabled);
        verify(mockLocationSource.getPermission());
      },
    );
  });
}
