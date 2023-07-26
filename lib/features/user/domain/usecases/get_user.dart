import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repository/user_repository.dart';

class GetUserParams extends Equatable {
  final String? id;
  final bool? searchLocally;

  GetUserParams({
    required this.id,
    required this.searchLocally,
  });

  @override
  List<Object?> get props => [id];
}

class GetUser implements UseCase<User?, GetUserParams> {
  final UserRepository? repository;

  GetUser(this.repository);

  @override
  Future<Either<Failure, User?>> call(GetUserParams params) {
    return repository!.getUser(
      id: params.id,
      searchLocally: params.searchLocally,
    );
  }
}
