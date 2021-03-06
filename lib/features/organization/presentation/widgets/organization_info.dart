import 'package:flutter/material.dart';

import '../../../../core/util/localized_string.dart';
import '../../../../core/widgets/avatar.dart';
import '../../../../core/widgets/text_with_label.dart';
import '../../domain/entities/organization.dart';

class OrganizationInfo extends StatelessWidget {
  final Organization organization;
  final LocalizedString localizedString;
  final bool canEdit;
  final Function onAvatarPress;
  final Function onChangeOrganizationPress;

  const OrganizationInfo({
    Key key,
    @required this.organization,
    @required this.localizedString,
    this.canEdit = false,
    this.onAvatarPress,
    this.onChangeOrganizationPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
      child: Column(
        children: [
          GestureDetector(
            onTap: canEdit ? onAvatarPress : null,
            child: Avatar(
              url: organization?.avatarUrl,
              canEdit: canEdit,
            ),
          ),
          if (organization?.name != null) SizedBox(height: 12),
          if (organization?.name != null)
            GestureDetector(
              onTap: onChangeOrganizationPress,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      organization?.name ?? '',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  SizedBox(width: 8),
                  if (onChangeOrganizationPress != null)
                    RotatedBox(
                      quarterTurns: 3,
                      child: Icon(
                        Icons.chevron_left_outlined,
                        size: 30,
                        color: Theme.of(context).textTheme.headline4.color,
                      ),
                    ),
                ],
              ),
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
                value: organization?.members?.length?.toString() ?? '',
              ),
              // if (canEdit)
              //   RaisedButton.icon(
              //     onPressed: () {},
              //     icon: Icon(Icons.edit),
              //     label: Text(
              //       localizedString.getLocalizedString(
              //         'organization-screen.edit-button',
              //       ),
              //     ),
              //   ),
              // Padding(
              //   padding: canEdit
              //       ? const EdgeInsets.only(top: 0, bottom: 8)
              //       : const EdgeInsets.symmetric(vertical: 8),
              //   child: Divider(),
              // ),
              // ! REMOVE THIS WIDGET ONCE EDIT BUTTON IS BACK
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Divider(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
