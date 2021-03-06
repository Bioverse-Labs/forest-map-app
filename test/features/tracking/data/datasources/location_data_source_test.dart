import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forestMapApp/core/adapters/firestore_adapter.dart';
import 'package:forestMapApp/core/enums/exception_origin_types.dart';
import 'package:forestMapApp/core/errors/exceptions.dart';
import 'package:forestMapApp/core/platform/location.dart';
import 'package:forestMapApp/features/tracking/data/datasources/location_data_source.dart';
import 'package:forestMapApp/features/tracking/data/models/location_model.dart';
import 'package:forestMapApp/features/tracking/domain/entities/location.dart';
import 'package:mockito/mockito.dart';

class MockLocationUtilsImpl extends Mock implements LocationUtilsImpl {}

class MockFirestoreAdapterImpl extends Mock implements FirestoreAdapterImpl {}

class MockDocumentReference extends Mock implements DocumentReference {}

void main() {
  MockLocationUtilsImpl mockLocationUtilsImpl;
  MockFirestoreAdapterImpl mockFirestoreAdapterImpl;
  MockDocumentReference mockDocumentReference;
  LocationDataSourceImpl locationDataSourceImpl;

  setUp(() {
    mockLocationUtilsImpl = MockLocationUtilsImpl();
    mockFirestoreAdapterImpl = MockFirestoreAdapterImpl();
    mockDocumentReference = MockDocumentReference();
    locationDataSourceImpl = LocationDataSourceImpl(
      locationUtils: mockLocationUtilsImpl,
      firestoreAdapter: mockFirestoreAdapterImpl,
    );
  });

  void hasPermission(Function body) {
    group('has Permission', () {
      setUp(() {
        when(mockLocationUtilsImpl.checkLocationPermission())
            .thenAnswer((_) async => true);
      });

      body();
    });
  }

  void doesNotHavePermission(Function body) {
    group('does not have Permission', () {
      setUp(() {
        when(mockLocationUtilsImpl.checkLocationPermission())
            .thenAnswer((_) async => false);
      });

      body();
    });
  }

  final tId = faker.guid.guid();
  final tLat = faker.randomGenerator.decimal();
  final tLng = faker.randomGenerator.decimal();
  final tTimestamp = faker.date.dateTime();

  final tLocationModel = LocationModel(
    id: tId,
    lat: tLat,
    lng: tLng,
    timestamp: tTimestamp,
    accuracy: faker.randomGenerator.decimal(),
    altitude: faker.randomGenerator.decimal(),
    floor: faker.randomGenerator.integer(2),
    heading: faker.randomGenerator.decimal(),
    speed: faker.randomGenerator.decimal(),
    speedAccuracy: faker.randomGenerator.decimal(),
  );

  group('getPositionStream', () {
    hasPermission(() {
      final tLocationStream = StreamController<Location>();

      test(
        'should return [Stream] if utils succeed',
        () async {
          when(mockLocationUtilsImpl.getLocationStream(any))
              .thenAnswer((_) async => tLocationStream.stream);

          final result = await locationDataSourceImpl.getPositionStream();
          expect(result, tLocationStream.stream);
          verify(mockLocationUtilsImpl.checkLocationPermission());
          verify(mockLocationUtilsImpl.getLocationStream(true));
          verifyNoMoreInteractions(mockLocationUtilsImpl);
          tLocationStream.close();
        },
      );
    });

    doesNotHavePermission(() {
      test(
        'should throw [LocalException] if user does not have permission',
        () async {
          when(mockLocationUtilsImpl.getLocationStream(any)).thenThrow(
            LocalException(
              'no permission',
              '403',
              ExceptionOriginTypes.test,
            ),
          );

          try {
            await locationDataSourceImpl.getPositionStream();
          } catch (error) {
            expect(error, isInstanceOf<LocalException>());
          }

          verify(mockLocationUtilsImpl.checkLocationPermission());
          verify(mockLocationUtilsImpl.getLocationStream(false));
          verifyNoMoreInteractions(mockLocationUtilsImpl);
        },
      );
    });
  });

  group('getCurrentLocation', () {
    hasPermission(() {
      test(
        'should return [LocatioModel] if utils succeed',
        () async {
          when(mockLocationUtilsImpl.getCurrentPosition(any))
              .thenAnswer((_) async => tLocationModel);

          final result = await locationDataSourceImpl.getCurrentLocation();
          expect(result, tLocationModel);
          verify(mockLocationUtilsImpl.checkLocationPermission());
          verify(mockLocationUtilsImpl.getCurrentPosition(true));
          verifyNoMoreInteractions(mockLocationUtilsImpl);
        },
      );
    });

    doesNotHavePermission(() {
      test(
        'should throw [LocalException] if user does not have permission',
        () async {
          when(mockLocationUtilsImpl.getCurrentPosition(any)).thenThrow(
            LocalException(
              'no permission',
              '403',
              ExceptionOriginTypes.test,
            ),
          );

          try {
            await locationDataSourceImpl.getCurrentLocation();
          } catch (error) {
            expect(error, isInstanceOf<LocalException>());
          }

          verify(mockLocationUtilsImpl.checkLocationPermission());
          verify(mockLocationUtilsImpl.getCurrentPosition(false));
          verifyNoMoreInteractions(mockLocationUtilsImpl);
        },
      );
    });
  });

  group('saveLocation', () {
    final tUserId = faker.guid.guid();

    test(
      'should return [LocationModel] if adapter succeed',
      () async {
        when(mockFirestoreAdapterImpl.addDocument(any, any))
            .thenAnswer((_) async => mockDocumentReference);

        final payload = tLocationModel.toMap();
        final result = await locationDataSourceImpl.saveLocation(
          tUserId,
          payload,
        );

        expect(result, tLocationModel);
        verify(mockFirestoreAdapterImpl.addDocument(
          'users/$tUserId/tracking/${payload['id']}',
          payload,
        ));
        verifyNoMoreInteractions(mockFirestoreAdapterImpl);
      },
    );
  });
}
