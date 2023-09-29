import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/enums/organization_member_status.dart';
import '../../../../core/enums/organization_role_types.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/organization.dart';
import '../repositories/organization_repository.dart';

class UpdateMemberParams extends Equatable {
  final String? id;
  final String? userId;
  final OrganizationRoleType? role;
  final OrganizationMemberStatus? status;

  UpdateMemberParams({
    required this.id,
    required this.userId,
    this.role,
    this.status,
  });

  @override
  List<Object?> get props => [id, userId, role, status];
}

class UpdateMember implements UseCase<Organization, UpdateMemberParams> {
  final OrganizationRepository? organizationRepository;

  UpdateMember(this.organizationRepository);

  @override
  Future<Either<Failure, Organization>> call(UpdateMemberParams params) {
    return organizationRepository!.updateMember(
      id: params.id,
      userId: params.userId,
      role: params.role,
      status: params.status,
    );
  }
}
