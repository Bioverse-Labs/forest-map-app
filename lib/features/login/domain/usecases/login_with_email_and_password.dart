import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:forestMapApp/core/entities/user.dart';
import 'package:forestMapApp/core/errors/failure.dart';
import 'package:forestMapApp/core/usecases/usecase.dart';

import '../repositories/login_repository.dart';

class LoginWithEmailAndPassword implements UseCase<User, LoginParams> {
  final LoginRepository repository;

  LoginWithEmailAndPassword(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    return await repository.loginWithEmailAndPassword(
      params.email,
      params.password,
    );
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  LoginParams(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}
