import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forest_map/core/errors/failure.dart';
import 'package:forest_map/core/usecases/usecase.dart';
import 'package:forest_map/features/post/domain/entities/post.dart';
import 'package:forest_map/features/post/domain/repositories/post_repository.dart';
import 'package:forest_map/features/post/domain/usecases/upload_cached_post.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'upload_cached_post_test.mocks.dart';

@GenerateMocks([PostRepository])
void main() {
  late MockPostRepository mockPostRepository;
  late UploadCachedPost uploadCachedPost;

  setUp(() {
    mockPostRepository = MockPostRepository();
    uploadCachedPost = UploadCachedPost(mockPostRepository);
  });

  final tStream = StreamController<Either<Failure, Post>>();

  test('should return [Stream] if upload start', () async {
    when(mockPostRepository.uploadCachedPost())
        .thenAnswer((_) async => Right(tStream));

    final result = await uploadCachedPost(NoParams());

    expect(result, Right(tStream));
    verify(mockPostRepository.uploadCachedPost());
    verifyNoMoreInteractions(mockPostRepository);

    tStream.close();
  });
}
