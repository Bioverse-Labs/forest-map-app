import 'package:dartz/dartz.dart';

import '../../../../core/enums/social_login_types.dart';
import '../../../../core/errors/failure.dart';
import '../../../user/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signInWithEmailAndPassword(
    String email,
    String password,
  );
  Future<Either<Failure, User>> signInWithSocial(SocialLoginType type);
  Future<Either<Failure, User>> signUp(
    String name,
    String email,
    String password,
  );
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, void>> forgotPassword(String email);
}
