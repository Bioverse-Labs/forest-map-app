import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:forestMapApp/core/enums/organization_role_types.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/organization.dart';
import '../repositories/organization_repository.dart';

class UpdateMemberParams extends Equatable {
  final String id;
  final String userId;
  final OrganizationRoleType type;

  UpdateMemberParams({
    @required this.id,
    @required this.userId,
    @required this.type,
  });

  @override
  List<Object> get props => [id, userId];
}

class UpdateMember implements UseCase<Organization, UpdateMemberParams> {
  final OrganizationRepository organizationRepository;

  UpdateMember(this.organizationRepository);

  @override
  Future<Either<Failure, Organization>> call(UpdateMemberParams params) {
    return organizationRepository.updateMember(
      id: params.id,
      userId: params.userId,
      type: params.type,
    );
  }
}
