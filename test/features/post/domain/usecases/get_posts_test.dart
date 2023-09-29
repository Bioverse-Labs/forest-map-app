import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forest_map/features/post/domain/repositories/post_repository.dart';
import 'package:forest_map/features/post/domain/usecases/get_posts.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_posts_test.mocks.dart';

@GenerateMocks([PostRepository])
void main() {
  late MockPostRepository mockPostRepository;
  late GetPosts getPosts;

  setUp(() {
    mockPostRepository = MockPostRepository();
    getPosts = GetPosts(mockPostRepository);
  });

  final tOrgId = faker.guid.guid();

  test('should get posts', () async {
    when(mockPostRepository.getPosts(
      orgId: anyNamed('orgId'),
    )).thenAnswer((_) async => Right([]));

    final result = await getPosts(GetPostsParams(tOrgId));

    result.fold(
      (failure) => null,
      (posts) => expect(posts, isA<List>()),
    );
    verify(mockPostRepository.getPosts(orgId: tOrgId));
    verifyNoMoreInteractions(mockPostRepository);
  });
}
