import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/organization.dart';
import '../repositories/organization_repository.dart';

class RemoveMemberParams extends Equatable {
  final String id;
  final String userId;

  RemoveMemberParams({
    @required this.id,
    @required this.userId,
  });

  @override
  List<Object> get props => [id, userId];
}

class RemoveMember implements UseCase<Organization, RemoveMemberParams> {
  final OrganizationRepository organizationRepository;

  RemoveMember(this.organizationRepository);

  @override
  Future<Either<Failure, Organization>> call(RemoveMemberParams params) {
    return organizationRepository.removeMember(
      id: params.id,
      userId: params.userId,
    );
  }
}
