import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:forestMapApp/features/organization/data/datasources/organization_local_data_source.dart';
import 'package:meta/meta.dart';

import '../../../../core/enums/organization_member_status.dart';
import '../../../../core/enums/organization_role_types.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../user/domain/entities/user.dart';
import '../../domain/entities/organization.dart';
import '../../domain/repositories/organization_repository.dart';
import '../datasources/organization_remote_data_source.dart';

typedef Future<Organization> _DSExecutor();

class OrganizationRepositoryImpl implements OrganizationRepository {
  final OrganizationRemoteDataSource remoteDataSource;
  final OrganizationLocalDataSource localDataSource;

  OrganizationRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
  });

  @override
  Future<Either<Failure, Organization>> createOrganization({
    @required User user,
    @required String name,
    @required String email,
    @required String phone,
    File avatar,
  }) {
    return _getOrganization(() => remoteDataSource.createOrganization(
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
      return Right(await remoteDataSource.deleteOrganization(id));
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
    return _getOrganization(() => remoteDataSource.getOrganization(id));
  }

  @override
  Future<Either<Failure, Organization>> inviteUserToOrganization({
    @required String id,
    @required User user,
  }) {
    return _getOrganization(
      () => remoteDataSource.inviteUserToOrganization(id: id, user: user),
    );
  }

  @override
  Future<Either<Failure, Organization>> removeMember({
    @required String id,
    @required String userId,
  }) {
    return _getOrganization(
      () => remoteDataSource.removeMember(id: id, userId: userId),
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
      () => remoteDataSource.updateMember(
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
    return _getOrganization(() => remoteDataSource.updateOrganization(
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

  @override
  Future<Either<Failure, void>> saveOrganizationLocally({
    String id,
    Organization organization,
  }) async {
    try {
      return Right(await localDataSource.saveOrganization(
        id: id,
        organization: organization,
      ));
    } on LocalException catch (error) {
      return Left(LocalFailure(
        error.message,
        error.code,
        error.origin,
        stackTrace: error.stackTrace,
      ));
    }
  }
}
