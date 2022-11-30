import 'package:flutter/material.dart';

import '../../../../core/enums/organization_role_types.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../../../../core/util/localized_string.dart';
import '../../../../core/util/notifications.dart';
import '../../domain/entities/member.dart';
import '../../domain/entities/organization.dart';
import '../notifiers/organizations_notifier.dart';

class MemberListItem extends StatelessWidget {
  final Member member;
  final Organization organization;
  final OrganizationNotifierImpl organizationNotifier;
  final NotificationsUtils notificationsUtils;
  final AppNavigator appNavigator;
  final LocalizedString localizedString;

  const MemberListItem({
    Key key,
    @required this.member,
    @required this.organization,
    @required this.organizationNotifier,
    @required this.notificationsUtils,
    @required this.appNavigator,
    @required this.localizedString,
  }) : super(key: key);

  bool _canEdit() {
    final result = organization.members
        .where(
          (el) => el.id != member.id && el.role == OrganizationRoleType.owner,
        )
        .toList();

    if (result.length <= 0) {
      notificationsUtils.showErrorNotification(
        localizedString.getLocalizedString('members-role-validation'),
      );
      return false;
    }

    return true;
  }

  Future<void> _onEditPress(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.5,
          child: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 32,
            ),
            children: [
              Text(
                'Edit Member Role',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline5,
              ),
              SizedBox(height: 16),
              Card(
                child: ListTile(
                  title: Text(localizedString.getLocalizedString(
                    'members-role.owner',
                  )),
                  trailing: member.role == OrganizationRoleType.owner
                      ? Icon(Icons.circle)
                      : Container(width: 5),
                  onTap: () {
                    appNavigator.pop();
                    if (_canEdit()) {
                      organizationNotifier.updateMember(
                        id: organization.id,
                        userId: member.id,
                        role: OrganizationRoleType.owner,
                      );
                    }
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: Text(localizedString.getLocalizedString(
                    'members-role.admin',
                  )),
                  trailing: member.role == OrganizationRoleType.admin
                      ? Icon(Icons.circle)
                      : Container(width: 5),
                  onTap: () {
                    appNavigator.pop();
                    if (_canEdit()) {
                      organizationNotifier.updateMember(
                        id: organization.id,
                        userId: member.id,
                        role: OrganizationRoleType.admin,
                      );
                    }
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: Text(localizedString.getLocalizedString(
                    'members-role.member',
                  )),
                  trailing: member.role == OrganizationRoleType.member
                      ? Icon(Icons.circle)
                      : Container(width: 5),
                  onTap: () {
                    appNavigator.pop();
                    if (_canEdit()) {
                      organizationNotifier.updateMember(
                        id: organization.id,
                        userId: member.id,
                        role: OrganizationRoleType.member,
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Divider(),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  label: Text('Remove Member'),
                  icon: Icon(Icons.person_remove),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.red,
                    ),
                  ),
                  onPressed: () {
                    appNavigator.pop();
                    if (_canEdit()) {
                      organizationNotifier.removeMember(
                        id: organization.id,
                        userId: member.id,
                      );
                    }
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }

  String _getRoleString(OrganizationRoleType role) {
    switch (role) {
      case OrganizationRoleType.owner:
        return localizedString.getLocalizedString('members-role.owner');
      case OrganizationRoleType.admin:
        return localizedString.getLocalizedString('members-role.admin');
      case OrganizationRoleType.member:
        return localizedString.getLocalizedString('members-role.member');
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('${member.name} - ${_getRoleString(member.role)}'),
        trailing: Icon(Icons.edit),
        onTap: () => _onEditPress(context),
      ),
    );
  }
}

class MemberList extends StatelessWidget {
  final Organization organization;
  final OrganizationNotifierImpl organizationNotifier;
  final NotificationsUtils notificationsUtils;
  final AppNavigator appNavigator;
  final LocalizedString localizedString;

  const MemberList({
    Key key,
    @required this.organization,
    @required this.organizationNotifier,
    @required this.notificationsUtils,
    @required this.appNavigator,
    @required this.localizedString,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    organization.members.sort((a, b) => b.role.index.compareTo(a.role.index));
    return Column(
      children: [
        ...organization.members
            .map(
              (member) => MemberListItem(
                member: member,
                organization: organization,
                organizationNotifier: organizationNotifier,
                notificationsUtils: notificationsUtils,
                appNavigator: appNavigator,
                localizedString: localizedString,
              ),
            )
            .toList(),
      ],
    );
  }
}
