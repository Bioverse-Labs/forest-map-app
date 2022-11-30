// import 'package:faker/faker.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:forest_map_app/features/post/data/hive/post.dart';
// import 'package:forest_map_app/features/post/data/models/post_model.dart';
// import 'package:forest_map_app/features/post/domain/entities/post.dart';
// import 'package:forest_map_app/features/tracking/data/models/location_model.dart';

// void main() {
//   final id = faker.guid.guid();
//   final userId = faker.guid.guid();
//   final imageUrl = faker.image.image();
//   final specie = faker.randomGenerator.string(20);
//   final timestamp = faker.date.dateTime();
//   final location = LocationModel(
//     id: faker.guid.guid(),
//     lat: faker.randomGenerator.decimal(),
//     lng: faker.randomGenerator.decimal(),
//     timestamp: faker.date.dateTime(),
//   );

//   final tPostModel = PostModel.fromMap({
//     ...location.toMap(),
//     'id': id,
//     'userId': userId,
//     'specie': specie,
//     'imageUrl': imageUrl,
//     'timestamp': timestamp,
//   });

//   test('should be subclass of Post entity', () async {
//     expect(tPostModel, isA<Post>());
//   });

//   group('fromMap', () {
//     test('should return a valid model when the map is valid', () {
//       final map = {
//         ...location.toMap(),
//         'id': id,
//         'userId': userId,
//         'specie': specie,
//         'imageUrl': imageUrl,
//         'timestamp': timestamp,
//       };

//       final result = PostModel.fromMap(map);
//       expect(result, tPostModel);
//     });
//   });

//   group('toMap', () {
//     test('should return map with user data', () {
//       final map = {
//         ...location.toMap(),
//         'id': id,
//         'userId': userId,
//         'specie': specie,
//         'imageUrl': imageUrl,
//         'timestamp': timestamp,
//       };

//       final result = tPostModel.toMap();

//       expect(result, map);
//     });
//   });

//   group('copyWith', () {
//     test(
//       'should return a new instance of [PostModel] with new data',
//       () async {
//         final result = tPostModel.copyWith(specie: faker.person.name());
//         expect(result, isNot(tPostModel));
//       },
//     );
//   });

//   test(
//     'should return [PostModel] if [Post] is valid',
//     () async {
//       final model = PostModel.fromEntity(tPostModel);

//       expect(model, isInstanceOf<PostModel>());
//     },
//   );

//   test(
//     'should return [HiveAdapter] if [PostModel] is valid',
//     () async {
//       final adapter = tPostModel.toHiveAdapter();

//       expect(adapter, isInstanceOf<PostHive>());
//     },
//   );

//   group('fromHive', () {
//     test(
//       'should return [PostModel] if [PostHive] is valid',
//       () async {
//         final model = PostModel.fromHive(tPostModel.toHiveAdapter());

//         expect(model, isInstanceOf<PostModel>());
//       },
//     );
//   });
// }
