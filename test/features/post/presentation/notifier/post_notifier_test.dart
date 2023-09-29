import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:forest_map/core/adapters/hive_adapter.dart';
import 'package:forest_map/core/enums/exception_origin_types.dart';
import 'package:forest_map/core/errors/failure.dart';
import 'package:forest_map/core/usecases/usecase.dart';
import 'package:forest_map/features/post/data/hive/pending_post.dart';
import 'package:forest_map/features/post/domain/entities/post.dart';
import 'package:forest_map/features/post/domain/usecases/get_posts.dart';
import 'package:forest_map/features/post/domain/usecases/save_post.dart';
import 'package:forest_map/features/post/domain/usecases/upload_cached_post.dart';
import 'package:forest_map/features/post/presentation/notifier/post_notifier.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../core/notifiers/change_notifiers.dart';

import 'post_notifier_test.mocks.dart';

@GenerateMocks([
  SavePost,
  GetPosts,
  UploadCachedPost,
  HiveAdapter,
])
void main() {
  late MockSavePost mockSavePost;
  late MockGetPosts mockGetPost;
  late MockUploadCachedPost mockUploadCachedPost;
  late MockHiveAdapter<PendingPostHive> mockHiveAdapter;
  late PostNotifierImpl postNotifierImpl;

  setUp(() {
    mockSavePost = MockSavePost();
    mockGetPost = MockGetPosts();
    mockUploadCachedPost = MockUploadCachedPost();
    mockHiveAdapter = MockHiveAdapter();
    postNotifierImpl = PostNotifierImpl(
      savePostUseCase: mockSavePost,
      uploadCachedPostUseCase: mockUploadCachedPost,
      getPostsUseCase: mockGetPost,
      postHive: mockHiveAdapter,
    );
  });

  final tUserId = faker.guid.guid();
  final tOrgId = faker.guid.guid();
  final tFile = File(faker.image.image());
  final tSpecie = faker.randomGenerator.string(20);
  final tStreamController = StreamController<Either<Failure, Post>>();

  group('savePost', () {
    test(
      'should set [User] and notifiy all listeners if usecase succeed',
      () async {
        when(mockSavePost(any)).thenAnswer((_) async => Right([]));

        await expectToNotifiyListener<PostNotifierImpl>(
          postNotifierImpl,
          () => postNotifierImpl.savePost(
            userId: tUserId,
            organizationId: tOrgId,
            file: tFile,
            specie: tSpecie,
          ),
          [
            NotifierAssertParams(
              value: (notifier) => notifier.isLoading,
              matcher: true,
            ),
            NotifierAssertParams(
              value: (notifier) => notifier.isLoading,
              matcher: false,
            ),
          ],
        );

        verify(mockSavePost(SavePostParams(
          userId: tUserId,
          organizationId: tOrgId,
          file: tFile,
          specie: tSpecie,
        )));
        verifyNoMoreInteractions(mockSavePost);
      },
    );

    test(
      'should throw [Failure] if useCase fails',
      () async {
        when(mockSavePost(any)).thenAnswer(
          (_) async => Left(
            ServerFailure(
              faker.randomGenerator.string(20),
              faker.randomGenerator.string(20),
              ExceptionOriginTypes.test,
            ),
          ),
        );

        final call = postNotifierImpl.savePost;

        expect(
          () => call(
            userId: tUserId,
            organizationId: tOrgId,
            file: tFile,
            specie: tSpecie,
          ),
          throwsA(isInstanceOf<ServerFailure>()),
        );

        verify(mockSavePost(SavePostParams(
          userId: tUserId,
          organizationId: tOrgId,
          file: tFile,
          specie: tSpecie,
        )));
        verifyNoMoreInteractions(mockSavePost);
      },
    );
  });

  group('uploadCachedPost', () {
    setUp(() {
      when(mockHiveAdapter.getKeys()).thenReturn([faker.guid.guid()]);
    });

    test(
      'should set [User] and notifiy all listeners if usecase succeed',
      () async {
        when(mockUploadCachedPost(any)).thenAnswer((_) async => Right(
              tStreamController,
            ));

        await expectToNotifiyListener<PostNotifierImpl>(
          postNotifierImpl,
          () => postNotifierImpl.uploadCachedPost(),
          [
            NotifierAssertParams(
              value: (notifier) => notifier.isLoading,
              matcher: true,
            ),
            NotifierAssertParams(
              value: (notifier) => notifier.isLoading,
              matcher: false,
            ),
            NotifierAssertParams(
              value: (notifier) => notifier.streamController,
              matcher: tStreamController,
            ),
          ],
        );

        tStreamController.close();

        verify(mockUploadCachedPost(NoParams()));
        verifyNoMoreInteractions(mockSavePost);
      },
    );

    test(
      'should throw [Failure] if useCase fails',
      () async {
        when(mockUploadCachedPost(any)).thenAnswer(
          (_) async => Left(
            ServerFailure(
              faker.randomGenerator.string(20),
              faker.randomGenerator.string(20),
              ExceptionOriginTypes.test,
            ),
          ),
        );

        final call = postNotifierImpl.uploadCachedPost;

        expect(
          () => call(),
          throwsA(isInstanceOf<ServerFailure>()),
        );

        tStreamController.close();

        verify(mockUploadCachedPost(NoParams()));
        verifyNoMoreInteractions(mockSavePost);
      },
    );
  });
}
