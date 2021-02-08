import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/enums/organization_role_types.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../../../../core/util/localized_string.dart';
import '../../../../core/widgets/screen.dart';
import '../../../user/domain/entities/user.dart';
import '../../../user/presentation/notifiers/user_notifier.dart';
import '../../domain/entities/organization.dart';
import '../notifiers/organizations_notifier.dart';
import '../widgets/empty_organizations.dart';
import '../widgets/organization_info.dart';

class OrganizationScreen extends StatelessWidget {
  final LocalizedString localizedString;
  final OrganizationNotifierImpl organizationNotifier;
  final AppNavigator appNavigator;
  final UserNotifierImpl userNotifier;

  const OrganizationScreen({
    Key key,
    @required this.localizedString,
    @required this.organizationNotifier,
    @required this.userNotifier,
    @required this.appNavigator,
  }) : super(key: key);

  OrganizationRoleType _getRole(User user, Organization organization) =>
      organization?.members
          ?.firstWhere((e) => e.id == user.id, orElse: null)
          ?.role;

  void _changeOrganization(BuildContext context) => showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * .6,
            child: ListView(
              children: userNotifier.user.organizations
                  .map(
                    (e) => ListTile(
                      title: Text(e.name),
                      onTap: () {
                        appNavigator.pop();
                      },
                    ),
                  )
                  .toList(),
            ),
          );
        },
      );

  Widget _renderBody(BuildContext context) {
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
              onChangeOrganizationPress: () => _changeOrganization(context),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWidget(
      body: _renderBody(context),
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
