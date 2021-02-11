import 'dart:io';

import '../../../tracking/domain/entities/location.dart';
import '../models/post_model.dart';

abstract class PostLocalDataSource {
  Future<void> savePost({
    String organizationId,
    String userId,
    String specie,
    File file,
    Location location,
  });

  Future<List<PostModel>> getAllPosts();
}
