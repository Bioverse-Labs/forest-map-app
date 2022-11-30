import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../organization/domain/entities/organization.dart';
import '../entities/user.dart';
import '../repository/user_repository.dart';

class UpdateUserParams extends Equatable {
  final String id;
  final String name;
  final String email;
  final List<Organization> organizations;
  final File avatar;

  UpdateUserParams({
    @required this.id,
    this.name,
    this.email,
    this.organizations,
    this.avatar,
  });

  @override
  List<Object> get props => [id, name, email, organizations, avatar];
}

class UpdateUser implements UseCase<User, UpdateUserParams> {
  final UserRepository repository;

  UpdateUser(this.repository);

  @override
  Future<Either<Failure, User>> call(UpdateUserParams params) {
    return repository.updateUser(
      id: params.id,
      name: params.name,
      email: params.email,
      organizations: params.organizations,
      avatar: params.avatar,
    );
  }
}
