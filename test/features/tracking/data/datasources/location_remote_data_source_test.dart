import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forest_map/core/adapters/firestore_adapter.dart';
import 'package:forest_map/core/adapters/hive_adapter.dart';
import 'package:forest_map/core/enums/exception_origin_types.dart';
import 'package:forest_map/core/errors/exceptions.dart';
import 'package:forest_map/core/platform/location.dart';
import 'package:forest_map/features/tracking/data/datasources/location_remote_data_source.dart';
import 'package:forest_map/features/tracking/data/models/location_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'location_remote_data_source_test.mocks.dart';

@GenerateMocks([
  LocationUtilsImpl,
  FirestoreAdapterImpl,
  DocumentReference,
  HiveAdapter,
  CollectionReference,
  FirebaseFirestore,
], customMocks: [
  MockSpec<QueryDocumentSnapshot<Map<String, dynamic>>>(
    as: #MockQueryDocumentSnapshot,
  ),
])
void main() {
  late MockLocationUtilsImpl mockLocationUtilsImpl;
  late MockFirestoreAdapterImpl mockFirestoreAdapterImpl;
  late MockDocumentReference<Map<String, dynamic>> mockDocumentReference;
  late LocationRemoteDataSource locationRemoteDataSourceImpl;
  late MockCollectionReference<Map<String, dynamic>> mockCollectionReference;
  late MockQueryDocumentSnapshot mockQueryDocumentSnapshot;
  late MockFirebaseFirestore mockFirebaseFirestore;

  final tId = faker.guid.guid();
  final tLat = faker.randomGenerator.decimal();
  final tLng = faker.randomGenerator.decimal();
  final tTimestamp = DateTime.now();

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

  setUp(() {
    mockLocationUtilsImpl = MockLocationUtilsImpl();
    mockFirestoreAdapterImpl = MockFirestoreAdapterImpl();
    mockDocumentReference = MockDocumentReference();
    mockCollectionReference = MockCollectionReference();
    mockQueryDocumentSnapshot = MockQueryDocumentSnapshot();
    mockFirebaseFirestore = MockFirebaseFirestore();
    locationRemoteDataSourceImpl = LocationRemoteDataSourceImpl(
      firestoreAdapter: mockFirestoreAdapterImpl,
    );

    when(mockFirestoreAdapterImpl.firestore).thenReturn(mockFirebaseFirestore);
    when(mockFirebaseFirestore.doc(any)).thenReturn(mockDocumentReference);
    when(mockDocumentReference.collection(any))
        .thenReturn(mockCollectionReference);
    when(mockFirestoreAdapterImpl.runQuery(any))
        .thenAnswer((_) async => [mockQueryDocumentSnapshot]);
    when(mockQueryDocumentSnapshot.data()).thenReturn(
      tLocationModel.toMap(),
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

  group('getCurrentLocation', () {
    hasPermission(() {
      test(
        'should return [LocatioModel] if succeed',
        () async {
          final result = await locationRemoteDataSourceImpl.getLocations(tId);
          expect(result, [tLocationModel]);
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
            await locationRemoteDataSourceImpl.getLocations(tId);
          } catch (error) {
            expect(error, isInstanceOf<LocalException>());
          }
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
        await locationRemoteDataSourceImpl.saveLocation(
          tUserId,
          tLocationModel,
        );

        verify(mockFirestoreAdapterImpl.addDocument(
          'users/$tUserId/tracking/${payload['id']}',
          payload,
        ));
        verifyNoMoreInteractions(mockFirestoreAdapterImpl);
      },
    );
  });
}
