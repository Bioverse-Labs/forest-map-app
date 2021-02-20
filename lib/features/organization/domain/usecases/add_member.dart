import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../user/domain/entities/user.dart';
import '../entities/organization.dart';
import '../repositories/organization_repository.dart';

class AddMemberParams extends Equatable {
  final String id;
  final User user;

  AddMemberParams({
    @required this.id,
    @required this.user,
  });

  @override
  List<Object> get props => [id];
}

class AddMember implements UseCase<Organization, AddMemberParams> {
  final OrganizationRepository organizationRepository;

  AddMember(this.organizationRepository);

  @override
  Future<Either<Failure, Organization>> call(AddMemberParams params) {
    return organizationRepository.addMember(
      id: params.id,
      user: params.user,
    );
  }
}
