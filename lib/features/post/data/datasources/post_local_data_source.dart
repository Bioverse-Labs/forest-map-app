import 'dart:io';

import '../hive/pending_post.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

import '../../../../core/adapters/hive_adapter.dart';
import '../../../../core/enums/exception_origin_types.dart';
import '../../../../core/errors/exceptions.dart';
import '../hive/post.dart';
import '../models/post_model.dart';

abstract class PostLocalDataSource {
  Future<void> savePost(PostModel post, {bool isPendingPost});
  Future<void> deletePost(String id, {bool isPendingPost});
  Future<void> syncPosts(List<PostModel> posts);
  Future<List<PostModel>> getAllOrgPosts(String orgId, {bool isPendingPost});
  Future<List<PostModel>> getAllPosts({bool isPendingPost});
}

class PostLocalDataSourceImpl implements PostLocalDataSource {
  final HiveAdapter<PostHive> postHiveAdapter;
  final HiveAdapter<PendingPostHive> pendingPostHiveAdapter;

  PostLocalDataSourceImpl({
    @required this.postHiveAdapter,
    @required this.pendingPostHiveAdapter,
  });

  @override
  Future<List<PostModel>> getAllPosts({bool isPendingPost = false}) async {
    try {
      final posts = <PostModel>[];
      final adapter = _getAdapter(isPendingPost: isPendingPost);
      final keys = adapter.getKeys();

      for (var key in keys) {
        final postObject = await adapter.get(key);
        posts.add(PostModel.fromHive(postObject));
      }

      return posts;
    } on HiveError catch (error) {
      throw LocalException(
        error.message,
        error.message,
        ExceptionOriginTypes.hive,
      );
    }
  }

  @override
  Future<void> savePost(PostModel post, {bool isPendingPost = false}) async {
    final adapter = _getAdapter(isPendingPost: isPendingPost);
    try {
      await adapter.put(
        post.id,
        isPendingPost ? post.toPendingPostHiveAdapter() : post.toHiveAdapter(),
      );
    } on HiveError catch (error) {
      throw LocalException(
        error.message,
        error.message,
        ExceptionOriginTypes.hive,
      );
    }
  }

  @override
  Future<void> deletePost(String id, {bool isPendingPost = false}) async {
    final adapter = _getAdapter(isPendingPost: isPendingPost);
    final postObject = await adapter.get(id) as dynamic;
    final file = File(postObject.imageUrl);

    if (file.existsSync()) {
      file.deleteSync();
    }
    await adapter.delete(id);
  }

  @override
  Future<List<PostModel>> getAllOrgPosts(
    String orgId, {
    bool isPendingPost = false,
  }) async {
    final posts = <PostModel>[];
    final adapter = _getAdapter(isPendingPost: isPendingPost);
    final keys = adapter?.getKeys();

    for (var key in keys) {
      final postObject = await adapter.get(key) as dynamic;

      if (postObject?.organizationId == orgId) {
        posts.add(PostModel.fromHive(postObject));
      }
    }

    return posts;
  }

  HiveAdapter<Object> _getAdapter({bool isPendingPost = false}) =>
      isPendingPost ? pendingPostHiveAdapter : postHiveAdapter;

  @override
  Future<void> syncPosts(List<PostModel> posts) async {
    try {
      await postHiveAdapter.deleteAll();

      for (var post in posts) {
        await postHiveAdapter.put(post.id, post.toHiveAdapter());
      }
    } on HiveError catch (error) {
      throw LocalException(
        error.message,
        error.hashCode.toString(),
        ExceptionOriginTypes.hive,
        stackTrace: error.stackTrace,
      );
    }
  }
}
