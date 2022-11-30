import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../../../../core/util/localized_string.dart';
import '../../../../core/util/notifications.dart';
import '../../../../core/widgets/screen.dart';
import '../../../user/presentation/notifiers/user_notifier.dart';
import '../notifiers/organization_invite_notifier.dart';
import '../notifiers/organizations_notifier.dart';
import '../widgets/organization_info.dart';

class OrganizationInviteScreen extends StatefulWidget {
  final OrganizationInviteNotifierImpl organizationInviteNotifier;
  final OrganizationNotifierImpl organizationNotifier;
  final UserNotifierImpl userNotifier;
  final NotificationsUtils notificationsUtils;
  final LocalizedString localizedString;
  final AppNavigator appNavigator;

  const OrganizationInviteScreen({
    Key key,
    @required this.organizationInviteNotifier,
    @required this.organizationNotifier,
    @required this.userNotifier,
    @required this.notificationsUtils,
    @required this.localizedString,
    @required this.appNavigator,
  }) : super(key: key);

  @override
  _OrganizationInviteScreenState createState() =>
      _OrganizationInviteScreenState();
}

class _OrganizationInviteScreenState extends State<OrganizationInviteScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(
      const Duration(milliseconds: 400),
      () {
        try {
          widget.organizationInviteNotifier.getOrganization(
            widget.organizationInviteNotifier.organizationId,
          );
        } on ServerFailure catch (failure) {
          widget.notificationsUtils.showErrorNotification(failure.message);
        }
      },
    );
  }

  Future<void> _acceptInvite() async {
    try {
      await widget.organizationInviteNotifier.acceptInvite(
        widget.organizationInviteNotifier.organization.id,
        widget.userNotifier.user,
      );

      await widget.organizationNotifier.setOrganization(
        id: 'currOrg',
        organization: widget.organizationInviteNotifier.organization,
      );

      await widget.userNotifier.getUser(
        id: widget.userNotifier.user.id,
        searchLocally: false,
      );

      widget.appNavigator.pop();
    } on ServerFailure catch (failure) {
      widget.notificationsUtils.showErrorNotification(failure.message);
    } on LocalFailure catch (failure) {
      widget.notificationsUtils.showErrorNotification(failure.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWidget(
      appBar: AppBar(
        title: Text(
          widget.localizedString.getLocalizedString(
            'organization-invite-screen.title',
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          OrganizationInfo(
            organization: widget.organizationInviteNotifier.organization,
            localizedString: widget.localizedString,
            hideGeoData: true,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: ListBody(
              children: [
                SizedBox(height: 16),
                Text(
                  widget.localizedString.getLocalizedString(
                    'organization-invite-screen.description',
                  ),
                  style: Theme.of(context).textTheme.headline5,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _acceptInvite,
                  child: Text(
                    widget.localizedString.getLocalizedString(
                      'organization-invite-screen.button',
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      isLoading:
          Provider.of<OrganizationInviteNotifierImpl>(context).isLoading ||
              Provider.of<UserNotifierImpl>(context).isLoading,
    );
  }
}
