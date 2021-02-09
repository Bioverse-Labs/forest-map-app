import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/organization.dart';
import '../repositories/organization_repository.dart';

class GetOrganizationParams extends Equatable {
  final String id;
  final bool searchLocally;

  GetOrganizationParams({
    @required this.id,
    @required this.searchLocally,
  });

  @override
  List<Object> get props => [id];
}

class GetOrganization implements UseCase<Organization, GetOrganizationParams> {
  final OrganizationRepository organizationRepository;

  GetOrganization(this.organizationRepository);

  @override
  Future<Either<Failure, Organization>> call(GetOrganizationParams params) {
    return organizationRepository.getOrganization(
      id: params.id,
      searchLocally: params.searchLocally,
    );
  }
}
