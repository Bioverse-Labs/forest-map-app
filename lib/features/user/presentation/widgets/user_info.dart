import 'package:flutter/material.dart';

import '../../../../core/util/localized_string.dart';
import '../../../../core/widgets/avatar.dart';
import '../../../../core/widgets/text_with_label.dart';
import '../../domain/entities/user.dart';

class UserInfo extends StatelessWidget {
  final User user;
  final LocalizedString localizedString;
  final Function onAvatarPress;

  const UserInfo({
    Key key,
    @required this.user,
    this.localizedString,
    this.onAvatarPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: onAvatarPress,
            child: Avatar(
              url: user?.avatarUrl,
              canEdit: true,
            ),
          ),
          if (user?.name != null) SizedBox(height: 12),
          if (user?.name != null)
            Text(
              user?.name ?? '',
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
                value: user?.email ?? '',
              ),
              SizedBox(height: 8),
              TextWithLabel(
                label: localizedString.getLocalizedString(
                  'profile-screen.organization-counter',
                ),
                value: user?.organizations?.length.toString() ?? '',
              ),
              // if (canEdit)
              //   ElevatedButton.icon(
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
            ],
          ),
        ],
      ),
    );
  }
}
