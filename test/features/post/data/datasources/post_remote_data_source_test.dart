// import 'dart:io';

// import 'package:faker/faker.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:forest_map/core/adapters/firebase_storage_adapter.dart';
// import 'package:forest_map/core/adapters/firestore_adapter.dart';
// import 'package:forest_map/core/errors/exceptions.dart';
// import 'package:forest_map/core/util/localized_string.dart';
// import 'package:forest_map/core/util/uuid_generator.dart';
// import 'package:forest_map/features/post/data/datasources/post_remote_data_source.dart';
// import 'package:forest_map/features/tracking/data/models/location_model.dart';
// import 'package:mockito/mockito.dart';

// class MockFirestoreAdapter extends Mock implements FirestoreAdapterImpl {}

// class MockFirebaseStorage extends Mock implements FirebasStorageAdapter {}

// class MockLocalizedString extends Mock implements LocalizedString {}

// class MockUUIDGenerator extends Mock implements UUIDGenerator {}

// class MockUploadTask extends Mock implements UploadTask {}

// void main() {
//   MockFirestoreAdapter mockFirestoreAdapter;
//   MockFirebaseStorage mockFirebaseStorage;
//   MockLocalizedString mockLocalizedString;
//   MockUUIDGenerator mockUUIDGenerator;
//   PostRemoteDataSourceImpl postRemoteDataSourceImpl;

//   setUp(() {
//     mockFirestoreAdapter = MockFirestoreAdapter();
//     mockFirebaseStorage = MockFirebaseStorage();
//     mockLocalizedString = MockLocalizedString();
//     mockUUIDGenerator = MockUUIDGenerator();
//     postRemoteDataSourceImpl = PostRemoteDataSourceImpl(
//       firestoreAdapter: mockFirestoreAdapter,
//       firebaseStorageAdapter: mockFirebaseStorage,
//       localizedString: mockLocalizedString,
//       uuidGenerator: mockUUIDGenerator,
//     );
//   });

//   final tSpecie = faker.randomGenerator.string(20);
//   final tUserId = faker.guid.guid();
//   final tOrgId = faker.guid.guid();
//   final tImageUrl = faker.image.image();
//   final tFile = File(tImageUrl);
//   final tLocation = LocationModel(
//     id: faker.guid.guid(),
//     lat: faker.randomGenerator.decimal(),
//     lng: faker.randomGenerator.decimal(),
//     timestamp: faker.date.dateTime(),
//   );
//   final tPostId = faker.guid.guid();
//   final tFirebaseException = FirebaseException(
//     plugin: 'firestore',
//     message: faker.randomGenerator.string(20),
//   );

//   group('savePost', () {
//     test(
//       'should save [Post]',
//       () async {
//         when(mockFirebaseStorage.uploadFile(
//           file: anyNamed('file'),
//           storagePath: anyNamed('storagePath'),
//         )).thenAnswer((_) => null);
//         when(mockFirebaseStorage.getDownloadUrl(any)).thenAnswer(
//           (_) async => tImageUrl,
//         );
//         when(mockUUIDGenerator.generateUID()).thenReturn(tPostId);

//         when(mockFirestoreAdapter.addDocument(any, any))
//             .thenAnswer((_) => null);

//         await postRemoteDataSourceImpl.savePost(
//           organizationId: tOrgId,
//           userId: tUserId,
//           specie: tSpecie,
//           file: tFile,
//           location: tLocation,
//         );

//         verify(mockFirebaseStorage.getDownloadUrl(
//           'organizations/$tOrgId/posts/$tPostId.png',
//         ));
//         verify(mockFirebaseStorage.uploadFile(
//           file: tFile,
//           storagePath: 'organizations/$tOrgId/posts/$tPostId.png',
//         ));
//         verifyNoMoreInteractions(mockFirebaseStorage);
//       },
//     );

//     test(
//       'should throw [ServerException] if adapter fails',
//       () async {
//         when(mockFirebaseStorage.uploadFile(
//           file: anyNamed('file'),
//           storagePath: anyNamed('storagePath'),
//         )).thenAnswer((_) => null);
//         when(mockFirebaseStorage.getDownloadUrl(any)).thenAnswer(
//           (_) async => tImageUrl,
//         );
//         when(mockUUIDGenerator.generateUID()).thenReturn(tPostId);

//         when(mockFirestoreAdapter.addDocument(any, any)).thenThrow(
//           tFirebaseException,
//         );

//         try {
//           await postRemoteDataSourceImpl.savePost(
//             organizationId: tOrgId,
//             userId: tUserId,
//             specie: tSpecie,
//             file: tFile,
//             location: tLocation,
//           );
//         } catch (error) {
//           expect(
//             error,
//             isInstanceOf<ServerException>(),
//           );
//         }

//         verify(mockFirebaseStorage.getDownloadUrl(
//           'organizations/$tOrgId/posts/$tPostId.png',
//         ));
//         verify(mockFirebaseStorage.uploadFile(
//           file: tFile,
//           storagePath: 'organizations/$tOrgId/posts/$tPostId.png',
//         ));
//         verifyNoMoreInteractions(mockFirebaseStorage);
//       },
//     );
//   });
// }
