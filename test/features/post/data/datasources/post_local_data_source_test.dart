// import 'dart:io';

// import 'package:faker/faker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:forest_map_app/core/adapters/hive_adapter.dart';
// import 'package:forest_map_app/core/errors/exceptions.dart';
// import 'package:forest_map_app/core/util/uuid_generator.dart';
// import 'package:forest_map_app/features/post/data/datasources/post_local_data_source.dart';
// import 'package:forest_map_app/features/post/data/hive/post.dart';
// import 'package:forest_map_app/features/post/data/models/post_model.dart';
// import 'package:forest_map_app/features/tracking/data/models/location_model.dart';
// import 'package:hive/hive.dart';
// import 'package:mockito/mockito.dart';

// class MockUploadTask extends Mock implements UploadTask {}

// class MockHiveAdapter extends Mock implements HiveAdapter<PostHive> {}

// class MockUUIDGenerator extends Mock implements UUIDGenerator {}

// void main() {
//   MockHiveAdapter mockHiveAdapter;
//   MockUUIDGenerator mockUUIDGenerator;
//   PostLocalDataSourceImpl postLocalDataSourceImpl;

//   setUp(() {
//     mockHiveAdapter = MockHiveAdapter();
//     mockUUIDGenerator = MockUUIDGenerator();
//     postLocalDataSourceImpl = PostLocalDataSourceImpl(
//       hiveAdapter: mockHiveAdapter,
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
//   final tPostHive = PostHive()
//     ..id = tPostId
//     ..userId = tUserId
//     ..organizationId = tOrgId
//     ..specie = tSpecie
//     ..imageUrl = tImageUrl
//     ..location = LocationModel.fromEntity(tLocation).toHiveAdapter();

//   final tHiveError = HiveError(faker.randomGenerator.string(20));
//   group('getAllPosts', () {
//     test(
//       'should return [List<PostModel>] if adapter succeed',
//       () async {
//         when(mockHiveAdapter.getKeys()).thenReturn([tPostId]);
//         when(mockHiveAdapter.get(any)).thenAnswer((_) async => tPostHive);

//         final result = await postLocalDataSourceImpl.getAllPosts();

//         expect(result, [PostModel.fromHive(tPostHive)]);
//         verify(mockHiveAdapter.getKeys());
//         verify(mockHiveAdapter.get(tPostId));
//         verifyNoMoreInteractions(mockHiveAdapter);
//       },
//     );

//     test(
//       'should thow [LocalException] if adapter failed',
//       () async {
//         when(mockHiveAdapter.getKeys()).thenReturn([tPostId]);
//         when(mockHiveAdapter.get(any)).thenThrow(tHiveError);

//         try {
//           await postLocalDataSourceImpl.getAllPosts();
//         } catch (error) {
//           expect(error, isInstanceOf<LocalException>());
//         }

//         verify(mockHiveAdapter.getKeys());
//         verify(mockHiveAdapter.get(tPostId));
//         verifyNoMoreInteractions(mockHiveAdapter);
//       },
//     );
//   });

//   group('savePost', () {
//     test(
//       'should save [Post]',
//       () async {
//         when(mockUUIDGenerator.generateUID()).thenReturn(tPostId);
//         when(mockHiveAdapter.put(any, any)).thenAnswer((_) async => null);

//         await postLocalDataSourceImpl.savePost(
//           organizationId: tOrgId,
//           userId: tUserId,
//           specie: tSpecie,
//           file: tFile,
//           location: tLocation,
//         );

//         verify(mockHiveAdapter.put(any, any)).called(1);
//       },
//     );

//     test(
//       'should throw [LocalException]',
//       () async {
//         when(mockUUIDGenerator.generateUID()).thenReturn(tPostId);
//         when(mockHiveAdapter.put(any, any)).thenThrow(tHiveError);

//         try {
//           await postLocalDataSourceImpl.savePost(
//             organizationId: tOrgId,
//             userId: tUserId,
//             specie: tSpecie,
//             file: tFile,
//             location: tLocation,
//           );
//         } catch (error) {
//           expect(error, isInstanceOf<LocalException>());
//         }

//         verify(mockHiveAdapter.put(any, any)).called(1);
//       },
//     );
//   });
// }
