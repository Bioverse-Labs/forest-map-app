import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forest_map/features/post/domain/repositories/post_repository.dart';
import 'package:forest_map/features/post/domain/usecases/save_post.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'save_post_test.mocks.dart';

@GenerateMocks([PostRepository])
void main() {
  late MockPostRepository mockPostRepository;
  late SavePost savePost;

  setUp(() {
    mockPostRepository = MockPostRepository();
    savePost = SavePost(mockPostRepository);
  });

  final tSpecie = faker.randomGenerator.string(20);
  final tFile = File(faker.image.image());
  final tOrgId = faker.guid.guid();
  final tUserId = faker.guid.guid();

  test('should save post', () async {
    when(mockPostRepository.savePost(
      userId: anyNamed('userId'),
      organizationId: anyNamed('organizationId'),
      file: anyNamed('file'),
      specie: anyNamed('specie'),
    )).thenAnswer((_) async => Right([]));

    await savePost(SavePostParams(
      userId: tUserId,
      organizationId: tOrgId,
      file: tFile,
      specie: tSpecie,
    ));

    verify(mockPostRepository.savePost(
      userId: tUserId,
      organizationId: tOrgId,
      file: tFile,
      specie: tSpecie,
    ));
    verifyNoMoreInteractions(mockPostRepository);
  });
}
