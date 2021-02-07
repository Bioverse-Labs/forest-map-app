import 'package:flutter/material.dart';
import 'package:forestMapApp/core/enums/organization_role_types.dart';
import 'package:forestMapApp/features/organization/domain/entities/organization.dart';
import 'package:forestMapApp/features/organization/presentation/widgets/empty_organizations.dart';
import 'package:forestMapApp/features/organization/presentation/widgets/organization_info.dart';
import 'package:forestMapApp/features/user/domain/entities/user.dart';
import 'package:provider/provider.dart';

import '../../../../core/util/localized_string.dart';
import '../../../../core/widgets/screen.dart';
import '../../../user/presentation/notifiers/user_notifier.dart';
import '../notifiers/organizations_notifier.dart';

class OrganizationScreen extends StatelessWidget {
  final LocalizedString localizedString;
  final OrganizationNotifierImpl organizationNotifier;
  final UserNotifierImpl userNotifier;

  const OrganizationScreen({
    Key key,
    @required this.localizedString,
    @required this.organizationNotifier,
    @required this.userNotifier,
  }) : super(key: key);

  OrganizationRoleType _getRole(User user, Organization organization) =>
      organization?.members
          ?.firstWhere((e) => e.id == user.id, orElse: null)
          ?.role;

  Widget _renderBody() {
    final user = userNotifier.user;

    if (user.organizations == null || user.organizations.length <= 0) {
      return EmptyOrganizations(localizedString: localizedString);
    }

    final role = _getRole(user, user.organizations.first);

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OrganizationInfo(
              organization: user.organizations.first,
              localizedString: localizedString,
              canEdit: role == OrganizationRoleType.owner ||
                  role == OrganizationRoleType.admin,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWidget(
      body: _renderBody(),
      floatingActionButton: Consumer<OrganizationNotifierImpl>(
        builder: (ctx, state, _) {
          final role = _getRole(userNotifier.user, state.organization);
          if (role == OrganizationRoleType.owner ||
              role == OrganizationRoleType.admin) {
            return FloatingActionButton.extended(
              onPressed: () {},
              icon: Icon(Icons.person_add_alt_1_outlined),
              label: Text(localizedString.getLocalizedString(
                'organization-screen.invite-member-button',
              )),
              tooltip: localizedString.getLocalizedString(
                'organization-screen.invite-member-button-tooltip',
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
