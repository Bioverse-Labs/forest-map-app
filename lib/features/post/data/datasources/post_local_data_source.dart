import 'dart:io';

import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

import '../../../../core/adapters/hive_adapter.dart';
import '../../../../core/enums/exception_origin_types.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/util/uuid_generator.dart';
import '../../../tracking/data/models/location_model.dart';
import '../../../tracking/domain/entities/location.dart';
import '../hive/post.dart';
import '../models/post_model.dart';

abstract class PostLocalDataSource {
  Future<void> savePost({
    String organizationId,
    String userId,
    String specie,
    File file,
    Location location,
  });
  Future<void> deletePost(String id);

  Future<List<PostModel>> getAllPosts();
}

class PostLocalDataSourceImpl implements PostLocalDataSource {
  final HiveAdapter<PostHive> hiveAdapter;
  final UUIDGenerator uuidGenerator;

  PostLocalDataSourceImpl({
    @required this.hiveAdapter,
    @required this.uuidGenerator,
  });

  @override
  Future<List<PostModel>> getAllPosts() async {
    try {
      final posts = <PostModel>[];
      final keys = hiveAdapter.getKeys();

      for (var key in keys) {
        final postObject = await hiveAdapter.get(key);
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
  Future<void> savePost({
    @required String organizationId,
    @required String userId,
    @required String specie,
    @required File file,
    @required Location location,
  }) async {
    try {
      final id = uuidGenerator.generateUID();
      await hiveAdapter.put(
        id,
        PostHive()
          ..id = id
          ..userId = userId
          ..organizationId = organizationId
          ..specie = specie
          ..imageUrl = file.path
          ..location = LocationModel.fromEntity(location).toHiveAdapter(),
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
  Future<void> deletePost(String id) async {
    final postObject = await hiveAdapter.get(id);

    File(postObject.imageUrl).deleteSync();
    await hiveAdapter.delete(id);
  }
}
