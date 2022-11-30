import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/enums/organization_member_status.dart';
import '../../../../core/enums/organization_role_types.dart';
import '../../../../core/errors/failure.dart';
import '../../../user/domain/entities/user.dart';
import '../entities/organization.dart';

abstract class OrganizationRepository {
  Future<Either<Failure, Organization>> createOrganization({
    @required User user,
    @required String name,
    @required String email,
    @required String phone,
    File avatar,
  });
  Future<Either<Failure, Organization>> getOrganization({
    @required String id,
    @required bool searchLocally,
  });
  Future<Either<Failure, Organization>> updateOrganization({
    @required String id,
    String name,
    String email,
    String phone,
    File avatar,
  });
  Future<Either<Failure, void>> deleteOrganization(String id);
  Future<Either<Failure, Organization>> addMember({
    @required String id,
    @required User user,
  });
  Future<Either<Failure, Organization>> updateMember({
    @required String id,
    @required String userId,
    OrganizationRoleType role,
    OrganizationMemberStatus status,
  });
  Future<Either<Failure, Organization>> removeMember({
    @required String id,
    @required String userId,
  });
  Future<Either<Failure, void>> saveOrganizationLocally({
    @required String id,
    @required Organization organization,
  });
}
