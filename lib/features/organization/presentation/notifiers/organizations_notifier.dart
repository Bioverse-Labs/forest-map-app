import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../../../core/enums/organization_member_status.dart';
import '../../../../core/enums/organization_role_types.dart';
import '../../../auth/domain/entities/user.dart';
import '../../domain/entities/organization.dart';
import '../../domain/usecases/create_organization.dart';
import '../../domain/usecases/delete_organization.dart';
import '../../domain/usecases/get_organization.dart';
import '../../domain/usecases/remove_member.dart';
import '../../domain/usecases/update_member.dart';
import '../../domain/usecases/update_organization.dart';

abstract class OrganizationNotifier {
  Future<void> createOrganization({
    User user,
    String name,
    String email,
    String phone,
    File avatar,
  });
  Future<void> getOrganization(String id);
  Future<void> updateOrganization({
    String id,
    String name,
    String email,
    String phone,
    File avatar,
  });
  Future<void> deleteOrganization(String id);
  Future<void> generateInvitationLink(String id);
  Future<void> updateMember({
    String id,
    String userId,
    OrganizationRoleType role,
    OrganizationMemberStatus status,
  });
  Future<void> removeMember({
    String id,
    String userId,
  });
}

class OrganizationNotifierImpl extends ChangeNotifier
    implements OrganizationNotifier {
  final CreateOrganization createOrganizationUseCase;
  final GetOrganization getOrganizationUseCase;
  final UpdateOrganization updateOrganizationUseCase;
  final DeleteOrganization deleteOrganizationUseCase;
  final UpdateMember updateMemberUseCase;
  final RemoveMember removeMemberUseCase;

  Organization _organization;
  String _invitationLink;
  bool _loading;

  OrganizationNotifierImpl({
    @required this.createOrganizationUseCase,
    @required this.getOrganizationUseCase,
    @required this.updateOrganizationUseCase,
    @required this.deleteOrganizationUseCase,
    @required this.updateMemberUseCase,
    @required this.removeMemberUseCase,
  });

  Organization get organization => _organization;
  String get invitationLink => _invitationLink;
  bool get isLoading => _loading;

  @override
  Future<void> createOrganization({
    @required User user,
    @required String name,
    @required String email,
    @required String phone,
    File avatar,
  }) async {
    _loading = true;
    notifyListeners();
    final failureOrOrganization =
        await createOrganizationUseCase(CreateOrganizationParams(
      user: user,
      name: name,
      email: email,
      phone: phone,
      avatar: avatar,
    ));

    _loading = false;
    notifyListeners();

    failureOrOrganization.fold(
      (failure) => throw failure,
      (organization) {
        _organization = organization;
        notifyListeners();
      },
    );
  }

  @override
  Future<void> deleteOrganization(String id) async {
    _loading = true;
    notifyListeners();
    final failureOrOrganization = await deleteOrganizationUseCase(
      DeleteOrganizationParams(id),
    );

    _loading = false;
    notifyListeners();

    failureOrOrganization.fold(
      (failure) => throw failure,
      (_) {
        _organization = null;
        notifyListeners();
      },
    );
  }

  @override
  Future<void> generateInvitationLink(String id) {
    // TODO: implement generateInvitationLink
    throw UnimplementedError();
  }

  @override
  Future<void> getOrganization(String id) async {
    _loading = true;
    notifyListeners();
    final failureOrOrganization = await getOrganizationUseCase(
      GetOrganizationParams(id),
    );

    _loading = false;
    notifyListeners();

    failureOrOrganization.fold(
      (failure) => throw failure,
      (organization) {
        _organization = organization;
        notifyListeners();
      },
    );
  }

  @override
  Future<void> removeMember({
    @required String id,
    @required String userId,
  }) async {
    _loading = true;
    notifyListeners();

    final failureOrOrganization = await removeMemberUseCase(RemoveMemberParams(
      id: id,
      userId: userId,
    ));

    _loading = false;
    notifyListeners();

    failureOrOrganization.fold(
      (failure) => throw failure,
      (organization) {
        _organization = organization;
        notifyListeners();
      },
    );
  }

  @override
  Future<void> updateMember({
    @required String id,
    @required String userId,
    OrganizationRoleType role,
    OrganizationMemberStatus status,
  }) async {
    _loading = true;
    notifyListeners();

    final failureOrOrganization = await updateMemberUseCase(UpdateMemberParams(
      id: id,
      userId: userId,
      role: role,
      status: status,
    ));

    _loading = false;
    notifyListeners();

    failureOrOrganization.fold(
      (failure) => throw failure,
      (organization) {
        _organization = organization;
        notifyListeners();
      },
    );
  }

  @override
  Future<void> updateOrganization({
    @required String id,
    String name,
    String email,
    String phone,
    File avatar,
  }) async {
    _loading = true;
    notifyListeners();
    final failureOrOrganization =
        await updateOrganizationUseCase(UpdateOrganizationParams(
      id: id,
      name: name,
      email: email,
      phone: phone,
      avatar: avatar,
    ));

    _loading = false;
    notifyListeners();

    failureOrOrganization.fold(
      (failure) => throw failure,
      (organization) {
        _organization = organization;
        notifyListeners();
      },
    );
  }
}
