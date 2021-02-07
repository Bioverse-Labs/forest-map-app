import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:forestMapApp/core/enums/organization_member_status.dart';
import 'package:meta/meta.dart';

import '../../../../core/enums/organization_role_types.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../auth/domain/entities/user.dart';
import '../../domain/entities/organization.dart';
import '../../domain/repositories/organization_repository.dart';
import '../datasources/organization_data_source.dart';

typedef Future<Organization> _DSExecutor();

class OrganizationRepositoryImpl implements OrganizationRepository {
  final OrganizationDataSource dataSource;

  OrganizationRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, Organization>> createOrganization({
    @required User user,
    @required String name,
    @required String email,
    @required String phone,
    File avatar,
  }) {
    return _getOrganization(() => dataSource.createOrganization(
          user: user,
          name: name,
          email: email,
          phone: phone,
          avatar: avatar,
        ));
  }

  @override
  Future<Either<Failure, void>> deleteOrganization(String id) async {
    try {
      return Right(await dataSource.deleteOrganization(id));
    } on ServerException catch (error) {
      return Left(ServerFailure(
        error.message,
        error.code,
        error.origin,
        stackTrace: error.stackTrace,
      ));
    }
  }

  @override
  Future<Either<Failure, Organization>> getOrganization(String id) {
    return _getOrganization(() => dataSource.getOrganization(id));
  }

  @override
  Future<Either<Failure, Organization>> inviteUserToOrganization({
    @required String id,
    @required User user,
  }) {
    return _getOrganization(
      () => dataSource.inviteUserToOrganization(id: id, user: user),
    );
  }

  @override
  Future<Either<Failure, Organization>> removeMember({
    @required String id,
    @required String userId,
  }) {
    return _getOrganization(
      () => dataSource.removeMember(id: id, userId: userId),
    );
  }

  @override
  Future<Either<Failure, Organization>> updateMember({
    @required String id,
    @required String userId,
    OrganizationRoleType role,
    OrganizationMemberStatus status,
  }) {
    return _getOrganization(
      () => dataSource.updateMember(
        id: id,
        userId: userId,
        role: role,
        status: status,
      ),
    );
  }

  @override
  Future<Either<Failure, Organization>> updateOrganization({
    @required String id,
    String name,
    String email,
    String phone,
    File avatar,
  }) {
    return _getOrganization(() => dataSource.updateOrganization(
          id: id,
          name: name,
          email: email,
          phone: phone,
          avatar: avatar,
        ));
  }

  Future<Either<Failure, Organization>> _getOrganization(
    _DSExecutor dataSourceExecutor,
  ) async {
    try {
      return Right(await dataSourceExecutor());
    } on ServerException catch (error) {
      return Left(ServerFailure(
        error.message,
        error.code,
        error.origin,
        stackTrace: error.stackTrace,
      ));
    }
  }
}
