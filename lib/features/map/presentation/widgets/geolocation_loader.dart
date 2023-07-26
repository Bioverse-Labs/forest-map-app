import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/util/localized_string.dart';
import '../../../organization/domain/entities/organization.dart';
import '../notifiers/map_notifier.dart';

class GeolocationLoader extends StatelessWidget {
  final Organization organization;
  final LocalizedString localizedString;

  const GeolocationLoader({
    Key? key,
    required this.organization,
    required this.localizedString,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MapNotifierImpl>(
      builder: (ctx, state, _) {
        if (!state.isLoading) {
          return Container();
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 8),
                Text(localizedString.getLocalizedString(
                  'loading-geolocation-files',
                )),
              ],
            ),
          ),
        );
      },
    );
  }
}
