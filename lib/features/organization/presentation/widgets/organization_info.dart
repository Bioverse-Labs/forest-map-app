import 'package:flutter/material.dart';
import 'package:forestMapApp/core/util/localized_string.dart';
import 'package:forestMapApp/core/widgets/avatar.dart';
import 'package:forestMapApp/core/widgets/text_with_label.dart';
import 'package:forestMapApp/features/organization/domain/entities/organization.dart';

class OrganizationInfo extends StatelessWidget {
  final Organization organization;
  final LocalizedString localizedString;
  final bool canEdit;

  const OrganizationInfo({
    Key key,
    @required this.organization,
    this.localizedString,
    this.canEdit = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          Avatar(
            url: organization?.avatarUrl,
            canEdit: canEdit,
          ),
          if (organization?.name != null) SizedBox(height: 12),
          if (organization?.name != null)
            Text(
              organization?.name ?? '',
              style: Theme.of(context).textTheme.headline4,
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Divider(),
          ),
          ListBody(
            children: [
              TextWithLabel(
                label: localizedString.getLocalizedString('labels.email'),
                value: organization?.email ?? '',
              ),
              SizedBox(height: 8),
              TextWithLabel(
                label: localizedString.getLocalizedString('labels.phone'),
                value: organization?.phone ?? '',
              ),
              SizedBox(height: 8),
              TextWithLabel(
                label: localizedString.getLocalizedString(
                  'organization-screen.members-counter',
                ),
                value: organization?.members?.length.toString() ?? '',
              ),
              if (canEdit)
                RaisedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.edit),
                  label: Text(
                    localizedString.getLocalizedString(
                      'organization-screen.edit-button',
                    ),
                  ),
                ),
              Padding(
                padding: canEdit
                    ? const EdgeInsets.only(top: 0, bottom: 8)
                    : const EdgeInsets.symmetric(vertical: 8),
                child: Divider(),
              ),
            ],
          ),
          Text(
            localizedString.getLocalizedString(
              'organization-screen.data-section-title',
            ),
            style: Theme.of(context).textTheme.headline6,
          ),
          ListBody(
            children: [
              SizedBox(height: 16),
              Container(
                height: 100,
                child: Placeholder(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
