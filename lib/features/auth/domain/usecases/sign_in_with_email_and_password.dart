import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../user/domain/entities/user.dart';
import '../repositories/auth_repository.dart';

class SignInWithEmailAndPassword
    implements UseCase<User, SignInWithEmailAndPasswordParams> {
  final AuthRepository repository;

  SignInWithEmailAndPassword(this.repository);

  @override
  Future<Either<Failure, User>> call(
      SignInWithEmailAndPasswordParams params) async {
    return await repository.signInWithEmailAndPassword(
      params.email,
      params.password,
    );
  }
}

class SignInWithEmailAndPasswordParams extends Equatable {
  final String email;
  final String password;

  SignInWithEmailAndPasswordParams(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}
