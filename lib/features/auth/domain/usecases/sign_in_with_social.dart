import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/enums/social_login_types.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../user/domain/entities/user.dart';
import '../repositories/auth_repository.dart';

class SignInWithSocial implements UseCase<User, SignInWithSocialParams> {
  final AuthRepository? repository;

  SignInWithSocial(this.repository);

  @override
  Future<Either<Failure, User>> call(SignInWithSocialParams params) async {
    return await repository!.signInWithSocial(params.type);
  }
}

class SignInWithSocialParams extends Equatable {
  final SocialLoginType type;

  SignInWithSocialParams(this.type);

  @override
  List<Object> get props => [type];
}
