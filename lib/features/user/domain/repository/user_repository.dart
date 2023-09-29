import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../organization/domain/entities/organization.dart';
import '../entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, User?>> getUser({
    String? id,
    bool? searchLocally,
  });
  Future<Either<Failure, User>> updateUser({
    String? id,
    String? name,
    String? email,
    List<Organization>? organizations,
    File? avatar,
  });
}
