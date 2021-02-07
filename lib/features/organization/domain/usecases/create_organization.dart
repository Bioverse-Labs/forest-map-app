import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../user/domain/entities/user.dart';
import '../entities/organization.dart';
import '../repositories/organization_repository.dart';

class CreateOrganizationParams extends Equatable {
  final User user;
  final String name;
  final String email;
  final String phone;
  final File avatar;

  CreateOrganizationParams({
    @required this.user,
    @required this.name,
    @required this.email,
    @required this.phone,
    this.avatar,
  });

  @override
  List<Object> get props => [user, name, email, phone, avatar];
}

class CreateOrganization
    implements UseCase<Organization, CreateOrganizationParams> {
  final OrganizationRepository organizationRepository;

  CreateOrganization(this.organizationRepository);

  @override
  Future<Either<Failure, Organization>> call(CreateOrganizationParams params) {
    return organizationRepository.createOrganization(
      user: params.user,
      name: params.name,
      email: params.email,
      phone: params.phone,
      avatar: params.avatar,
    );
  }
}
