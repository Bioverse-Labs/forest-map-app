import 'package:dartz/dartz.dart';

import '../../../../core/enums/social_login_types.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/entities/user.dart';

abstract class LoginRepository {
  Future<Either<Failure, User>> loginWithEmailAndPassword(
    String email,
    String password,
  );
  Future<Either<Failure, User>> loginWithSocial(SocialLoginType type);
}
