import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/enums/organization_member_status.dart';
import '../../../../core/enums/organization_role_types.dart';
import '../../../user/domain/entities/user.dart';
import '../../domain/entities/organization.dart';
import '../../domain/usecases/create_organization.dart';
import '../../domain/usecases/delete_organization.dart';
import '../../domain/usecases/get_organization.dart';
import '../../domain/usecases/remove_member.dart';
import '../../domain/usecases/save_organization_locally.dart';
import '../../domain/usecases/update_member.dart';
import '../../domain/usecases/update_organization.dart';

abstract class OrganizationNotifier {
  Future<void> createOrganization({
    User? user,
    String? name,
    String? email,
    String? phone,
    File? avatar,
  });
  Future<void> getOrganization({String? id, bool? searchLocally});
  Future<void> updateOrganization({
    String? id,
    String? name,
    String? email,
    String? phone,
    File? avatar,
  });
  Future<void> deleteOrganization(String id);
  Future<void> updateMember({
    String? id,
    String? userId,
    OrganizationRoleType? role,
    OrganizationMemberStatus? status,
  });
  Future<void> removeMember({
    String? id,
    String? userId,
  });
  Future<void> setOrganization({String? id, Organization? organization});
}

class OrganizationNotifierImpl extends ChangeNotifier
    implements OrganizationNotifier {
  final CreateOrganization? createOrganizationUseCase;
  final GetOrganization? getOrganizationUseCase;
  final UpdateOrganization? updateOrganizationUseCase;
  final DeleteOrganization? deleteOrganizationUseCase;
  final SaveOrganizationLocally? saveOrganizationLocallyUseCase;
  final UpdateMember? updateMemberUseCase;
  final RemoveMember? removeMemberUseCase;

  Organization? _organization;
  String? _invitationLink;
  bool _loading = false;

  OrganizationNotifierImpl({
    required this.createOrganizationUseCase,
    required this.getOrganizationUseCase,
    required this.updateOrganizationUseCase,
    required this.deleteOrganizationUseCase,
    required this.saveOrganizationLocallyUseCase,
    required this.updateMemberUseCase,
    required this.removeMemberUseCase,
  });

  Organization? get organization => _organization;
  String? get invitationLink => _invitationLink;
  bool get isLoading => _loading;

  @override
  Future<void> createOrganization({
    User? user,
    String? name,
    String? email,
    String? phone,
    File? avatar,
  }) async {
    _loading = true;
    notifyListeners();
    final failureOrOrganization =
        await createOrganizationUseCase!(CreateOrganizationParams(
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
    final failureOrOrganization = await deleteOrganizationUseCase!(
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
  Future<void> getOrganization({
    String? id,
    bool? searchLocally = false,
  }) async {
    _loading = true;
    notifyListeners();
    final failureOrOrganization = await getOrganizationUseCase!(
      GetOrganizationParams(id: id, searchLocally: searchLocally),
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
    String? id,
    String? userId,
  }) async {
    _loading = true;
    notifyListeners();

    final failureOrOrganization = await removeMemberUseCase!(RemoveMemberParams(
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
    String? id,
    String? userId,
    OrganizationRoleType? role,
    OrganizationMemberStatus? status,
  }) async {
    _loading = true;
    notifyListeners();

    final failureOrOrganization = await updateMemberUseCase!(UpdateMemberParams(
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
    String? id,
    String? name,
    String? email,
    String? phone,
    File? avatar,
  }) async {
    _loading = true;
    notifyListeners();
    final failureOrOrganization =
        await updateOrganizationUseCase!(UpdateOrganizationParams(
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

  @override
  Future<void> setOrganization({
    String? id,
    Organization? organization,
  }) async {
    _organization = organization;
    notifyListeners();

    final failureOrOrganization = await saveOrganizationLocallyUseCase!(
      SaveOrganizationLocallyParams(
        id: id,
        organization: organization,
      ),
    );

    failureOrOrganization.fold(
      (failure) => throw failure,
      (_) {},
    );
  }
}
