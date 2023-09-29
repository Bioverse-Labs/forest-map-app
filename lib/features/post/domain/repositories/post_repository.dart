import 'dart:async';
import 'dart:io';

import '../../../catalog/domain/entities/catalog.dart';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/post.dart';

abstract class PostRepository {
  Future<Either<Failure, List<Post>>> savePost({
    String? organizationId,
    String? userId,
    File? file,
    Catalog? category,
    int? dbh,
    String? landUse,
    String? specie,
  });
  Future<Either<Failure, StreamController<Either<Failure, Post>>>>
      uploadCachedPost();
  Future<Either<Failure, List<Post>>> getPosts({required String? orgId});
}
