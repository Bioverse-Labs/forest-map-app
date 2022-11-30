import 'package:flutter/material.dart';

import '../../../../core/util/localized_string.dart';

class EmptyOrganizations extends StatelessWidget {
  final LocalizedString localizedString;
  final Function onPress;

  const EmptyOrganizations({
    Key key,
    @required this.localizedString,
    this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              localizedString.getLocalizedString(
                'organization-screen.empty-state-title',
              ),
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            if (onPress != null) SizedBox(height: 32),
            if (onPress != null)
              ElevatedButton(
                onPressed: onPress,
                child: Text(
                  localizedString.getLocalizedString(
                    'organization-screen.empty-state-button',
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
