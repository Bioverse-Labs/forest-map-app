import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../organization/domain/entities/organization.dart';
import '../repositories/post_repository.dart';

class SavePostParams extends Equatable {
  final String organizationId;
  final String userId;
  final File file;
  final String specie;

  SavePostParams({
    @required this.userId,
    @required this.organizationId,
    @required this.file,
    @required this.specie,
  });

  @override
  List<Object> get props => [userId, organizationId, file, specie];
}

class SavePost extends UseCase<void, SavePostParams> {
  final PostRepository repository;

  SavePost(this.repository);

  @override
  Future<Either<Failure, void>> call(SavePostParams params) {
    return repository.savePost(
      userId: params.userId,
      organizationId: params.organizationId,
      file: params.file,
      specie: params.specie,
    );
  }
}
