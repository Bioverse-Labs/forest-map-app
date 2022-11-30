import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/post.dart';
import '../repositories/post_repository.dart';

class GetPostsParams extends Equatable {
  final String orgId;

  GetPostsParams(this.orgId);

  @override
  List<Object> get props => [orgId];
}

class GetPosts implements UseCase<List<Post>, GetPostsParams> {
  final PostRepository _repository;

  GetPosts(this._repository);

  @override
  Future<Either<Failure, List<Post>>> call(GetPostsParams params) {
    return _repository.getPosts(orgId: params.orgId);
  }
}
