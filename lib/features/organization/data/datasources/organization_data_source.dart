import 'dart:io';

import 'package:meta/meta.dart';

import '../../../../core/enums/organization_role_types.dart';
import '../../../auth/domain/entities/user.dart';
import '../models/organization_model.dart';

abstract class OrganizationDataSource {
  /// creates new organization into organizations collection and adds
  /// user passed as params as [owner] of this new organization then
  /// adds an organization reference inside user [Document].
  Future<OrganizationModel> createOrganization({
    @required User user,
    @required String name,
    @required String email,
    @required String phone,
    File avatar,
  });

  /// return [Document] that matches [id] inside organizations
  /// collection
  Future<OrganizationModel> getOrganization(String id);

  /// update [Document] data that matches [id] inside organizations
  /// collection
  Future<OrganizationModel> updateOrganization({
    @required String id,
    @required String name,
    @required String email,
    @required String phone,
    File avatar,
  });

  /// remove [Document] from organizations collections that match [id]
  Future<void> deleteOrganization(String id);

  /// TODO: Use Firebase dynamic link to invite user
  Future<OrganizationModel> inviteUserToOrganization({
    @required String id,
    @required User user,
  });

  /// remove user from organization and remove organization reference from
  /// [User] document
  Future<OrganizationModel> removeMember({
    @required String id,
    @required String userId,
  });

  Future<OrganizationModel> updateMember({
    @required String id,
    @required String userId,
    @required OrganizationRoleType type,
  });
}
