import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../../../../core/enums/organization_role_types.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../../../../core/platform/camera.dart';
import '../../../../core/util/generate_invite_link.dart';
import '../../../../core/util/localized_string.dart';
import '../../../../core/util/notifications.dart';
import '../../../../core/widgets/screen.dart';
import '../../../user/domain/entities/user.dart';
import '../../../user/presentation/notifiers/user_notifier.dart';
import '../../domain/entities/organization.dart';
import '../notifiers/organizations_notifier.dart';
import '../widgets/empty_organizations.dart';
import '../widgets/members_list.dart';
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
          ?.firstWhere((e) => e.id == user.id, orElse: () => null)
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

  Future<void> _inviteMember() async {
    final failureOrUlr = await generateInviteLink(
      organizationNotifier.organization,
    );

    failureOrUlr.fold(
      (failure) => notificationsUtils.showErrorNotification(failure.message),
      (url) => Share.share(url.toString()),
    );
  }

  Widget _renderBody(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer2<UserNotifierImpl, OrganizationNotifierImpl>(
              builder: (ctx, userState, orgState, _) {
                final user = userState.user;
                final organization = orgState.organization;

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
            Consumer<OrganizationNotifierImpl>(
              builder: (ctx, state, _) {
                final user = userNotifier.user;
                final organization = state.organization;
                final role = _getRole(user, organization);

                if (role == OrganizationRoleType.owner ||
                    role == OrganizationRoleType.admin) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
                    child: ListBody(
                      children: [
                        Text(
                          localizedString.getLocalizedString(
                            'organization-screen.members-list',
                          ),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        SizedBox(height: 16),
                        MemberList(
                          organization: organizationNotifier.organization,
                          organizationNotifier: organizationNotifier,
                          notificationsUtils: notificationsUtils,
                          appNavigator: appNavigator,
                          localizedString: localizedString,
                        ),
                        SizedBox(height: 42),
                      ],
                    ),
                  );
                }

                return Container();
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
              heroTag: 'inviteUserFloatingButton',
              onPressed: _inviteMember,
              icon: Icon(Icons.person_add_alt_1_outlined),
              label: Text(localizedString.getLocalizedString(
                'organization-screen.invite-member-button',
              )),
              tooltip: localizedString.getLocalizedString(
                'organization-screen.invite-member-button-tooltip',
              ),
            );
          }
          return FloatingActionButton.extended(
            heroTag: 'inviteUserFloatingButton',
            onPressed: _inviteMember,
            icon: Icon(Icons.person_add_alt_1_outlined),
            label: Text(localizedString.getLocalizedString(
              'organization-screen.invite-member-button',
            )),
            tooltip: localizedString.getLocalizedString(
              'organization-screen.invite-member-button-tooltip',
            ),
          );
        },
      ),
      isLoading: Provider.of<OrganizationNotifierImpl>(context).isLoading,
    );
  }
}
