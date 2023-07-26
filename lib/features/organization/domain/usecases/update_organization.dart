import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/organization.dart';
import '../repositories/organization_repository.dart';

class UpdateOrganizationParams extends Equatable {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final File? avatar;

  UpdateOrganizationParams({
    required this.id,
    this.name,
    this.email,
    this.phone,
    this.avatar,
  });

  @override
  List<Object?> get props => [name, email, phone, avatar];
}

class UpdateOrganization
    implements UseCase<Organization, UpdateOrganizationParams> {
  final OrganizationRepository? organizationRepository;

  UpdateOrganization(this.organizationRepository);

  @override
  Future<Either<Failure, Organization>> call(UpdateOrganizationParams params) {
    return organizationRepository!.updateOrganization(
      id: params.id,
      name: params.name,
      email: params.email,
      phone: params.phone,
      avatar: params.avatar,
    );
  }
}
