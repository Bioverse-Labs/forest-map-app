import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/enums/organization_member_status.dart';
import '../../../../core/enums/organization_role_types.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/platform/network_info.dart';
import '../../../user/domain/entities/user.dart';
import '../../domain/entities/organization.dart';
import '../../domain/repositories/organization_repository.dart';
import '../datasources/organization_local_data_source.dart';
import '../datasources/organization_remote_data_source.dart';

typedef Future<Organization> _DSExecutor();

class OrganizationRepositoryImpl implements OrganizationRepository {
  final OrganizationRemoteDataSource remoteDataSource;
  final OrganizationLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  OrganizationRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
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
      if (!await networkInfo.isConnected) {
        return Left(NoInternetFailure());
      }

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
  Future<Either<Failure, Organization>> getOrganization({
    @required String id,
    @required bool searchLocally,
  }) async {
    try {
      if (searchLocally || !await networkInfo.isConnected) {
        return Right(await localDataSource.getOrganization(id));
      }

      return Right(await remoteDataSource.getOrganization(id));
    } on ServerException catch (error) {
      return Left(ServerFailure(
        error.message,
        error.code,
        error.origin,
        stackTrace: error.stackTrace,
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

  @override
  Future<Either<Failure, Organization>> addMember({
    @required String id,
    @required User user,
  }) {
    return _getOrganization(
      () => remoteDataSource.addMember(id: id, user: user),
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
      if (!await networkInfo.isConnected) {
        return Left(NoInternetFailure());
      }

      final organization = await dataSourceExecutor();
      await localDataSource.saveOrganization(
        id: 'currOrg',
        organization: organization,
      );

      return Right(organization);
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
