import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/organization_repository.dart';

class DeleteOrganizationParams extends Equatable {
  final String id;

  DeleteOrganizationParams(this.id);

  @override
  List<Object> get props => [id];
}

class DeleteOrganization implements UseCase<void, DeleteOrganizationParams> {
  final OrganizationRepository organizationRepository;

  DeleteOrganization(this.organizationRepository);

  @override
  Future<Either<Failure, void>> call(DeleteOrganizationParams params) {
    return organizationRepository.deleteOrganization(params.id);
  }
}
