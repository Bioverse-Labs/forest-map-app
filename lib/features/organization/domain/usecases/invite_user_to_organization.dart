import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../user/domain/entities/user.dart';
import '../entities/organization.dart';
import '../repositories/organization_repository.dart';

class InviteUserToOrganizationParams extends Equatable {
  final String id;
  final User user;

  InviteUserToOrganizationParams({
    @required this.id,
    @required this.user,
  });

  @override
  List<Object> get props => [id];
}

class InviteUserToOrganization
    implements UseCase<Organization, InviteUserToOrganizationParams> {
  final OrganizationRepository organizationRepository;

  InviteUserToOrganization(this.organizationRepository);

  @override
  Future<Either<Failure, Organization>> call(
      InviteUserToOrganizationParams params) {
    return organizationRepository.inviteUserToOrganization(
      id: params.id,
      user: params.user,
    );
  }
}
