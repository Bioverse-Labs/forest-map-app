import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/enums/organization_role_types.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../../../../core/platform/camera.dart';
import '../../../../core/util/localized_string.dart';
import '../../../../core/util/notifications.dart';
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
  final Camera camera;
  final NotificationsUtils notificationsUtils;

  const OrganizationScreen({
    Key key,
    @required this.localizedString,
    @required this.organizationNotifier,
    @required this.userNotifier,
    @required this.appNavigator,
    @required this.camera,
    @required this.notificationsUtils,
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
                    (organization) => ListTile(
                      title: Text(organization.name),
                      onTap: () {
                        organizationNotifier.setOrganization(
                          id: 'currOrg',
                          organization: organization,
                        );
                        appNavigator.pop();
                      },
                    ),
                  )
                  .toList(),
            ),
          );
        },
      );

  Future<void> _handleAvatarPress() async {
    try {
      final failureOrCameraResponse = await camera.takePicture();
      failureOrCameraResponse.fold(
        (failure) => notificationsUtils.showErrorNotification(
          localizedString.getLocalizedString('generic-exception'),
        ),
        (resp) => organizationNotifier.updateOrganization(
          id: organizationNotifier.organization.id,
          avatar: resp.file,
        ),
      );
    } on ServerFailure catch (failure) {
      notificationsUtils.showErrorNotification(failure.message);
    }
  }

  Widget _renderBody(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<OrganizationNotifierImpl>(
              builder: (ctx, state, _) {
                final user = userNotifier.user;
                final organization = organizationNotifier.organization;

                if (user.organizations == null ||
                    user.organizations.length <= 0) {
                  return EmptyOrganizations(localizedString: localizedString);
                }

                final role = _getRole(user, organization);

                return OrganizationInfo(
                  organization: organization,
                  localizedString: localizedString,
                  canEdit: role == OrganizationRoleType.owner ||
                      role == OrganizationRoleType.admin,
                  onChangeOrganizationPress: () => _changeOrganization(context),
                  onAvatarPress: () => _handleAvatarPress(),
                );
              },
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
      isLoading: Provider.of<OrganizationNotifierImpl>(context).isLoading,
    );
  }
}
