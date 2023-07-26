import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/organization.dart';
import '../repositories/organization_repository.dart';

class SaveOrganizationLocallyParams extends Equatable {
  final String? id;
  final Organization? organization;

  SaveOrganizationLocallyParams({
    required this.id,
    required this.organization,
  });

  @override
  List<Object?> get props => [organization];
}

class SaveOrganizationLocally
    implements UseCase<void, SaveOrganizationLocallyParams> {
  final OrganizationRepository? repository;

  SaveOrganizationLocally(this.repository);

  @override
  Future<Either<Failure, void>> call(SaveOrganizationLocallyParams params) {
    return repository!.saveOrganizationLocally(
      id: params.id,
      organization: params.organization,
    );
  }
}
