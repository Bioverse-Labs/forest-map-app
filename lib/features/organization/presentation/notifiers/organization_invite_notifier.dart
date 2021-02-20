import 'package:flutter/foundation.dart';

import '../../../user/domain/entities/user.dart';
import '../../domain/entities/organization.dart';
import '../../domain/usecases/add_member.dart';
import '../../domain/usecases/get_organization.dart';

abstract class OrganizationInviteNotifier {
  Future<void> getOrganization(String id);
  Future<void> acceptInvite(String id, User user);
}

class OrganizationInviteNotifierImpl extends ChangeNotifier
    implements OrganizationInviteNotifier {
  final GetOrganization getOrganizationUseCase;
  final AddMember addMemberUseCase;

  Organization _organization;
  String _orgId;
  bool _loading = false;
  bool _showInviteScreen = false;

  Organization get organization => _organization;
  String get organizationId => _orgId;
  bool get isLoading => _loading;
  bool get showScreen => _showInviteScreen;

  OrganizationInviteNotifierImpl({
    @required this.getOrganizationUseCase,
    @required this.addMemberUseCase,
  });

  @override
  Future<void> acceptInvite(String id, User user) async {
    _loading = true;
    notifyListeners();

    final failureOrOrganization = await addMemberUseCase(
      AddMemberParams(id: id, user: user),
    );

    failureOrOrganization.fold(
      (failure) => throw failure,
      (organization) {
        _organization = organization;
        notifyListeners();
      },
    );

    _loading = false;
    notifyListeners();
  }

  @override
  Future<void> getOrganization(String id) async {
    _loading = true;
    notifyListeners();

    final failureOrOrganization = await getOrganizationUseCase(
      GetOrganizationParams(
        id: id,
        searchLocally: false,
      ),
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

  void setOrgId(String orgId) {
    _orgId = orgId;
    _showInviteScreen = true;
    notifyListeners();
  }

  void setInviteScreenVisibility(bool show) {
    _showInviteScreen = show;
    notifyListeners();
  }
}
