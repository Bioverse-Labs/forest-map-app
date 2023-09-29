import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../catalog/domain/entities/catalog.dart';
import '../entities/post.dart';
import '../repositories/post_repository.dart';

class SavePostParams extends Equatable {
  final String? organizationId;
  final String? userId;
  final File? file;
  final Catalog? category;
  final String? landUse;
  final int? dbh;
  final String? specie;

  SavePostParams({
    required this.userId,
    required this.organizationId,
    required this.file,
    this.category,
    this.landUse,
    this.dbh,
    this.specie,
  });

  @override
  List<Object?> get props =>
      [userId, organizationId, file, category, landUse, dbh, specie];
}

class SavePost extends UseCase<List<Post>, SavePostParams> {
  final PostRepository? repository;

  SavePost(this.repository);

  @override
  Future<Either<Failure, List<Post>>> call(SavePostParams params) {
    return repository!.savePost(
      userId: params.userId,
      organizationId: params.organizationId,
      file: params.file,
      category: params.category,
      dbh: params.dbh,
      landUse: params.landUse,
      specie: params.specie,
    );
  }
}
