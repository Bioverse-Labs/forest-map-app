import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/post.dart';

abstract class PostRepository {
  Future<Either<Failure, void>> savePost({
    String organizationId,
    String userId,
    File file,
    String specie,
  });
  Future<Either<Failure, StreamController<Either<Failure, Post>>>>
      uploadCachedPost();
}
