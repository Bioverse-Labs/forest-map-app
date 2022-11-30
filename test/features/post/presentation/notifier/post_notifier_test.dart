// import 'dart:async';
// import 'dart:io';

// import 'package:dartz/dartz.dart';
// import 'package:faker/faker.dart';
// import 'package:forest_map_app/core/adapters/hive_adapter.dart';
// import 'package:forest_map_app/core/enums/exception_origin_types.dart';
// import 'package:forest_map_app/core/errors/failure.dart';
// import 'package:forest_map_app/core/usecases/usecase.dart';
// import 'package:forest_map_app/features/post/data/hive/post.dart';
// import 'package:forest_map_app/features/post/domain/entities/post.dart';
// import 'package:forest_map_app/features/post/domain/usecases/save_post.dart';
// import 'package:forest_map_app/features/post/domain/usecases/upload_cached_post.dart';
// import 'package:forest_map_app/features/post/presentation/notifier/post_notifier.dart';
// import 'package:mockito/mockito.dart';
// import 'package:flutter_test/flutter_test.dart';

// import '../../../../core/notifiers/change_notifiers.dart';

// class MockSavePost extends Mock implements SavePost {}

// class MockUploadCachedPost extends Mock implements UploadCachedPost {}

// class MockHiveAdapter extends Mock implements HiveAdapter<PostHive> {}

// void main() {
//   MockSavePost mockSavePost;
//   MockUploadCachedPost mockUploadCachedPost;
//   MockHiveAdapter mockHiveAdapter;
//   PostNotifierImpl postNotifierImpl;

//   setUp(() {
//     mockSavePost = MockSavePost();
//     mockUploadCachedPost = MockUploadCachedPost();
//     mockHiveAdapter = MockHiveAdapter();
//     postNotifierImpl = PostNotifierImpl(
//       savePostUseCase: mockSavePost,
//       uploadCachedPostUseCase: mockUploadCachedPost,
//       postHive: mockHiveAdapter,
//     );
//   });

//   final tUserId = faker.guid.guid();
//   final tOrgId = faker.guid.guid();
//   final tFile = File(faker.image.image());
//   final tSpecie = faker.randomGenerator.string(20);
//   final tStreamController = StreamController<Either<Failure, Post>>();

//   group('savePost', () {
//     test(
//       'should set [User] and notifiy all listeners if usecase succeed',
//       () async {
//         when(mockSavePost(any)).thenAnswer((_) async => Right(null));

//         await expectToNotifiyListener<PostNotifierImpl>(
//           postNotifierImpl,
//           () => postNotifierImpl.savePost(
//             userId: tUserId,
//             organizationId: tOrgId,
//             file: tFile,
//             specie: tSpecie,
//           ),
//           [
//             NotifierAssertParams(
//               value: (notifier) => notifier.isLoading,
//               matcher: true,
//             ),
//             NotifierAssertParams(
//               value: (notifier) => notifier.isLoading,
//               matcher: false,
//             ),
//           ],
//         );

//         verify(mockSavePost(SavePostParams(
//           userId: tUserId,
//           organizationId: tOrgId,
//           file: tFile,
//           specie: tSpecie,
//         )));
//         verifyNoMoreInteractions(mockSavePost);
//       },
//     );

//     test(
//       'should throw [Failure] if useCase fails',
//       () async {
//         when(mockSavePost(any)).thenAnswer(
//           (_) async => Left(
//             ServerFailure(
//               faker.randomGenerator.string(20),
//               faker.randomGenerator.string(20),
//               ExceptionOriginTypes.test,
//             ),
//           ),
//         );

//         final call = postNotifierImpl.savePost;

//         expect(
//           () => call(
//             userId: tUserId,
//             organizationId: tOrgId,
//             file: tFile,
//             specie: tSpecie,
//           ),
//           throwsA(isInstanceOf<ServerFailure>()),
//         );

//         verify(mockSavePost(SavePostParams(
//           userId: tUserId,
//           organizationId: tOrgId,
//           file: tFile,
//           specie: tSpecie,
//         )));
//         verifyNoMoreInteractions(mockSavePost);
//       },
//     );
//   });

//   group('uploadCachedPost', () {
//     setUp(() {
//       when(mockHiveAdapter.getKeys()).thenReturn([faker.guid.guid()]);
//     });

//     test(
//       'should set [User] and notifiy all listeners if usecase succeed',
//       () async {
//         when(mockUploadCachedPost(any)).thenAnswer((_) async => Right(
//               tStreamController,
//             ));

//         await expectToNotifiyListener<PostNotifierImpl>(
//           postNotifierImpl,
//           () => postNotifierImpl.uploadCachedPost(),
//           [
//             NotifierAssertParams(
//               value: (notifier) => notifier.isLoading,
//               matcher: true,
//             ),
//             NotifierAssertParams(
//               value: (notifier) => notifier.isLoading,
//               matcher: false,
//             ),
//             NotifierAssertParams(
//               value: (notifier) => notifier.streamController,
//               matcher: tStreamController,
//             ),
//           ],
//         );

//         tStreamController.close();

//         verify(mockUploadCachedPost(NoParams()));
//         verifyNoMoreInteractions(mockSavePost);
//       },
//     );

//     test(
//       'should throw [Failure] if useCase fails',
//       () async {
//         when(mockUploadCachedPost(any)).thenAnswer(
//           (_) async => Left(
//             ServerFailure(
//               faker.randomGenerator.string(20),
//               faker.randomGenerator.string(20),
//               ExceptionOriginTypes.test,
//             ),
//           ),
//         );

//         final call = postNotifierImpl.uploadCachedPost;

//         expect(
//           () => call(),
//           throwsA(isInstanceOf<ServerFailure>()),
//         );

//         tStreamController.close();

//         verify(mockUploadCachedPost(NoParams()));
//         verifyNoMoreInteractions(mockSavePost);
//       },
//     );
//   });
// }
