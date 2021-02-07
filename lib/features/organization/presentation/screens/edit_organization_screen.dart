import 'package:flutter/material.dart';
import 'package:forestMapApp/core/util/localized_string.dart';
import 'package:forestMapApp/core/util/notifications.dart';
import 'package:forestMapApp/core/widgets/screen.dart';
import 'package:forestMapApp/features/organization/presentation/notifiers/organizations_notifier.dart';

class EditOrganizationScreen extends StatelessWidget {
  final OrganizationNotifierImpl organizationNotifier;
  final LocalizedString localizedString;
  final NotificationsUtils notificationsUtils;

  EditOrganizationScreen({
    Key key,
    @required this.organizationNotifier,
    @required this.localizedString,
    @required this.notificationsUtils,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenWidget(
      appBar: AppBar(
        title: Text(
          localizedString.getLocalizedString('edit-organization-screen.title'),
        ),
      ),
      body: Container(),
    );
  }
}
