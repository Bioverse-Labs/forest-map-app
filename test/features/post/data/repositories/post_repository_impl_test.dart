// import 'dart:async';
// import 'dart:io';

// import 'package:dartz/dartz.dart';
// import 'package:faker/faker.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:forest_map_app/core/enums/exception_origin_types.dart';
// import 'package:forest_map_app/core/errors/exceptions.dart';
// import 'package:forest_map_app/core/errors/failure.dart';
// import 'package:forest_map_app/core/platform/location.dart';
// import 'package:forest_map_app/core/platform/network_info.dart';
// import 'package:forest_map_app/features/post/data/datasources/post_local_data_source.dart';
// import 'package:forest_map_app/features/post/data/datasources/post_remote_data_source.dart';
// import 'package:forest_map_app/features/post/data/models/post_model.dart';
// import 'package:forest_map_app/features/post/data/repositories/post_repository_impl.dart';
// import 'package:forest_map_app/features/post/domain/entities/post.dart';
// import 'package:forest_map_app/features/tracking/domain/entities/location.dart';
// import 'package:mockito/mockito.dart';

// class MockPostRemoteDataSource extends Mock implements PostRemoteDataSource {}

// class MockPostLocalDataSource extends Mock implements PostLocalDataSource {}

// class MockNetworkInfo extends Mock implements NetworkInfo {}

// class MockLocationUtils extends Mock implements LocationUtils {}

// void main() {
//   MockPostRemoteDataSource mockPostRemoteDataSource;
//   MockPostLocalDataSource mockPostLocalDataSource;
//   MockNetworkInfo mockNetworkInfo;
//   MockLocationUtils mockLocationUtils;
//   PostRepositoryImpl postRepositoryImpl;

//   setUp(() {
//     mockPostRemoteDataSource = MockPostRemoteDataSource();
//     mockPostLocalDataSource = MockPostLocalDataSource();
//     mockNetworkInfo = MockNetworkInfo();
//     mockLocationUtils = MockLocationUtils();
//     postRepositoryImpl = PostRepositoryImpl(
//       remoteDataSource: mockPostRemoteDataSource,
//       localDataSource: mockPostLocalDataSource,
//       networkInfo: mockNetworkInfo,
//       locationUtils: mockLocationUtils,
//     );
//   });

//   void runTestOnline(Function body) {
//     group('device is online', () {
//       setUp(() {
//         when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
//       });

//       body();
//     });
//   }

//   void runTestOffline(Function body) {
//     group('device is offline', () {
//       setUp(() {
//         when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
//       });

//       body();
//     });
//   }

//   final tUserId = faker.guid.guid();
//   final tOrgId = faker.guid.guid();
//   final tSpecie = faker.randomGenerator.string(20);
//   final tFile = File(faker.image.image());
//   final tLocation = Location(
//     id: faker.guid.guid(),
//     lat: faker.randomGenerator.decimal(),
//     lng: faker.randomGenerator.decimal(),
//     timestamp: faker.date.dateTime(),
//   );
//   final tServerException = ServerException(
//     faker.randomGenerator.string(20),
//     faker.randomGenerator.string(20),
//     ExceptionOriginTypes.test,
//   );
//   final tLocalException = LocalException(
//     faker.randomGenerator.string(20),
//     faker.randomGenerator.string(20),
//     ExceptionOriginTypes.test,
//   );
//   final tLocationException = LocationException(
//     faker.randomGenerator.string(20),
//     false,
//     false,
//   );
//   final tPost = Post(
//     id: faker.guid.guid(),
//     specie: tSpecie,
//     imageUrl: tFile.path,
//     timestamp: faker.date.dateTime(),
//     location: tLocation,
//     userId: tUserId,
//     organizationId: tOrgId,
//   );

//   runTestOnline(() {
//     group('savePost', () {
//       test(
//         'should save [Post] if datasource succeed',
//         () async {
//           when(mockPostRemoteDataSource.savePost(
//             userId: anyNamed('userId'),
//             organizationId: anyNamed('organizationId'),
//             specie: anyNamed('specie'),
//             file: anyNamed('file'),
//             location: anyNamed('location'),
//           )).thenAnswer((_) async => null);
//           when(mockLocationUtils.checkLocationPermission())
//               .thenAnswer((_) async => true);
//           when(mockLocationUtils.getCurrentPosition(any)).thenAnswer(
//             (_) async => tLocation,
//           );

//           final result = await postRepositoryImpl.savePost(
//             organizationId: tOrgId,
//             userId: tUserId,
//             file: tFile,
//             specie: tSpecie,
//           );

//           expect(result, Right(null));
//           verify(mockPostRemoteDataSource.savePost(
//             userId: tUserId,
//             organizationId: tOrgId,
//             file: tFile,
//             location: tLocation,
//             specie: tSpecie,
//           ));

//           verify(mockLocationUtils.checkLocationPermission());
//           verify(mockLocationUtils.getCurrentPosition(true));
//           verifyNoMoreInteractions(mockLocationUtils);
//           verifyNoMoreInteractions(mockPostRemoteDataSource);
//         },
//       );

//       test(
//         'should return [LocationFailure] if location fails',
//         () async {
//           when(mockLocationUtils.checkLocationPermission())
//               .thenThrow(tLocationException);

//           final result = await postRepositoryImpl.savePost(
//             organizationId: tOrgId,
//             userId: tUserId,
//             file: tFile,
//             specie: tSpecie,
//           );

//           expect(
//             result,
//             Left(LocationFailure(
//               tLocationException.message,
//               tLocationException.hasPermission,
//               tLocationException.isGpsEnabled,
//             )),
//           );

//           verify(mockLocationUtils.checkLocationPermission());
//           verifyNoMoreInteractions(mockLocationUtils);
//           verifyZeroInteractions(mockPostRemoteDataSource);
//         },
//       );

//       test(
//         'should throw [ServerException] when remote data source fails',
//         () async {
//           when(mockPostRemoteDataSource.savePost(
//             userId: anyNamed('userId'),
//             organizationId: anyNamed('organizationId'),
//             specie: anyNamed('specie'),
//             file: anyNamed('file'),
//             location: anyNamed('location'),
//           )).thenThrow(tServerException);
//           when(mockLocationUtils.checkLocationPermission())
//               .thenAnswer((_) async => true);
//           when(mockLocationUtils.getCurrentPosition(any)).thenAnswer(
//             (_) async => tLocation,
//           );

//           final result = await postRepositoryImpl.savePost(
//             organizationId: tOrgId,
//             userId: tUserId,
//             file: tFile,
//             specie: tSpecie,
//           );

//           expect(
//             result,
//             Left(ServerFailure(
//               tServerException.message,
//               tServerException.code,
//               tServerException.origin,
//             )),
//           );
//           verify(mockPostRemoteDataSource.savePost(
//             userId: tUserId,
//             organizationId: tOrgId,
//             file: tFile,
//             location: tLocation,
//             specie: tSpecie,
//           ));
//           verify(mockLocationUtils.checkLocationPermission());
//           verify(mockLocationUtils.getCurrentPosition(true));
//           verifyNoMoreInteractions(mockLocationUtils);
//           verifyNoMoreInteractions(mockPostRemoteDataSource);
//         },
//       );
//     });

//     group('uploadCachedPost', () {
//       test(
//         'should return [Stream] if datasource succeed',
//         () async {
//           when(mockPostLocalDataSource.getAllPosts())
//               .thenAnswer((_) async => [PostModel.fromEntity(tPost)]);

//           final result = await postRepositoryImpl.uploadCachedPost();

//           result.fold(
//             (l) => null,
//             (controller) => controller.stream.listen(expectAsync1((event) {
//               expect(event, Right(PostModel.fromEntity(tPost)));
//             })),
//           );

//           expect(
//             result,
//             isInstanceOf<
//                 Right<dynamic, StreamController<Either<Failure, Post>>>>(),
//           );

//           verify(mockPostLocalDataSource.getAllPosts());
//           verifyNoMoreInteractions(mockPostLocalDataSource);
//         },
//       );

//       test(
//         'should return [LocalFailure] if datasource succeed',
//         () async {
//           when(mockPostLocalDataSource.getAllPosts())
//               .thenThrow(tLocalException);

//           final result = await postRepositoryImpl.uploadCachedPost();

//           expect(
//             result,
//             Left(LocalFailure(
//               tLocalException.message,
//               tLocalException.code,
//               tLocalException.origin,
//             )),
//           );

//           verify(mockPostLocalDataSource.getAllPosts());
//           verifyNoMoreInteractions(mockPostLocalDataSource);
//         },
//       );

//       test(
//         'should return [ServerFailure] if datasource fails',
//         () async {
//           when(mockPostLocalDataSource.getAllPosts())
//               .thenAnswer((_) async => [PostModel.fromEntity(tPost)]);
//           when(mockPostRemoteDataSource.savePost(
//             userId: anyNamed('userId'),
//             organizationId: anyNamed('organizationId'),
//             specie: anyNamed('specie'),
//             file: anyNamed('file'),
//             location: anyNamed('location'),
//           )).thenThrow(tServerException);

//           final result = await postRepositoryImpl.uploadCachedPost();

//           result.fold(
//             (l) => null,
//             (controller) => controller.stream.listen(expectAsync1((event) {
//               expect(
//                 event,
//                 Left(
//                   ServerFailure(
//                     tServerException.message,
//                     tServerException.code,
//                     tServerException.origin,
//                   ),
//                 ),
//               );
//             })),
//           );
//           verify(mockPostLocalDataSource.getAllPosts());
//           verifyNoMoreInteractions(mockPostLocalDataSource);
//         },
//       );
//     });
//   });

//   runTestOffline(() {
//     group('savePost', () {
//       test(
//         'should save [Post] if datasource succeed',
//         () async {
//           when(mockPostLocalDataSource.savePost(
//             userId: anyNamed('userId'),
//             organizationId: anyNamed('organizationId'),
//             specie: anyNamed('specie'),
//             file: anyNamed('file'),
//             location: anyNamed('location'),
//           )).thenAnswer((_) async => null);
//           when(mockLocationUtils.checkLocationPermission())
//               .thenAnswer((_) async => true);
//           when(mockLocationUtils.getCurrentPosition(any)).thenAnswer(
//             (_) async => tLocation,
//           );

//           final result = await postRepositoryImpl.savePost(
//             organizationId: tOrgId,
//             userId: tUserId,
//             file: tFile,
//             specie: tSpecie,
//           );

//           expect(result, Right(null));
//           verify(mockPostLocalDataSource.savePost(
//             userId: tUserId,
//             organizationId: tOrgId,
//             file: tFile,
//             location: tLocation,
//             specie: tSpecie,
//           ));

//           verify(mockLocationUtils.checkLocationPermission());
//           verify(mockLocationUtils.getCurrentPosition(true));
//           verifyNoMoreInteractions(mockLocationUtils);
//           verifyNoMoreInteractions(mockPostRemoteDataSource);
//         },
//       );

//       test(
//         'should throw [LocalException] when remote data source fails',
//         () async {
//           when(mockPostLocalDataSource.savePost(
//             userId: anyNamed('userId'),
//             organizationId: anyNamed('organizationId'),
//             specie: anyNamed('specie'),
//             file: anyNamed('file'),
//             location: anyNamed('location'),
//           )).thenThrow(tLocalException);
//           when(mockLocationUtils.checkLocationPermission())
//               .thenAnswer((_) async => true);
//           when(mockLocationUtils.getCurrentPosition(any)).thenAnswer(
//             (_) async => tLocation,
//           );

//           final result = await postRepositoryImpl.savePost(
//             organizationId: tOrgId,
//             userId: tUserId,
//             file: tFile,
//             specie: tSpecie,
//           );

//           expect(
//             result,
//             Left(LocalFailure(
//               tLocalException.message,
//               tLocalException.code,
//               tLocalException.origin,
//             )),
//           );
//           verify(mockPostLocalDataSource.savePost(
//             userId: tUserId,
//             organizationId: tOrgId,
//             file: tFile,
//             location: tLocation,
//             specie: tSpecie,
//           ));
//           verify(mockLocationUtils.checkLocationPermission());
//           verify(mockLocationUtils.getCurrentPosition(true));
//           verifyNoMoreInteractions(mockLocationUtils);
//           verifyNoMoreInteractions(mockPostRemoteDataSource);
//         },
//       );
//     });

//     group('uploadCachedPost', () {
//       test(
//         'should return [NoInternetFailure] if datasource succeed',
//         () async {
//           when(mockPostLocalDataSource.getAllPosts())
//               .thenAnswer((_) async => [PostModel.fromEntity(tPost)]);

//           final result = await postRepositoryImpl.uploadCachedPost();

//           result.fold(
//             (l) => null,
//             (controller) => controller.stream.listen(expectAsync1((event) {
//               expect(event, Left(NoInternetFailure()));
//             })),
//           );

//           expect(
//             result,
//             isInstanceOf<
//                 Right<dynamic, StreamController<Either<Failure, Post>>>>(),
//           );

//           verify(mockPostLocalDataSource.getAllPosts());
//           verifyNoMoreInteractions(mockPostLocalDataSource);
//         },
//       );
//     });
//   });
// }
