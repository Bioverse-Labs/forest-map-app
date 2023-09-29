import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../user/domain/entities/user.dart';
import '../repositories/auth_repository.dart';

class SignUp implements UseCase<User, SignUpParams> {
  final AuthRepository? repository;

  SignUp(this.repository);

  @override
  Future<Either<Failure, User>> call(SignUpParams params) async {
    return await repository!.signUp(params.name, params.email, params.password);
  }
}

class SignUpParams extends Equatable {
  final String name;
  final String email;
  final String password;

  SignUpParams(this.name, this.email, this.password);

  @override
  List<Object> get props => [name, email, password];
}
