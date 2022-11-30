import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/post.dart';
import '../repositories/post_repository.dart';

class UploadCachedPost
    extends UseCase<StreamController<Either<Failure, Post>>, NoParams> {
  final PostRepository repository;

  UploadCachedPost(this.repository);

  @override
  Future<Either<Failure, StreamController<Either<Failure, Post>>>> call(
      NoParams params) {
    return repository.uploadCachedPost();
  }
}
