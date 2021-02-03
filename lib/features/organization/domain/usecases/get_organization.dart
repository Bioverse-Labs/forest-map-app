import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/organization.dart';
import '../repositories/organization_repository.dart';

class GetOrganizationParams extends Equatable {
  final String id;

  GetOrganizationParams(this.id);

  @override
  List<Object> get props => [id];
}

class GetOrganization implements UseCase<Organization, GetOrganizationParams> {
  final OrganizationRepository organizationRepository;

  GetOrganization(this.organizationRepository);

  @override
  Future<Either<Failure, Organization>> call(GetOrganizationParams params) {
    return organizationRepository.getOrganization(params.id);
  }
}
