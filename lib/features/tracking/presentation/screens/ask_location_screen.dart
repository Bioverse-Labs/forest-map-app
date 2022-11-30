import 'package:flutter/material.dart';
import 'package:forest_map_app/core/navigation/app_navigator.dart';
import 'package:forest_map_app/core/util/localized_string.dart';
import 'package:forest_map_app/core/widgets/screen.dart';
import 'package:forest_map_app/features/tracking/presentation/notifiers/location_notifier.dart';

class AskLocationScreen extends StatelessWidget {
  final LocalizedString localizedString;
  final LocationNotifierImpl locationNotifier;
  final AppNavigator appNavigator;

  const AskLocationScreen({
    Key key,
    @required this.localizedString,
    @required this.locationNotifier,
    @required this.appNavigator,
  }) : super(key: key);

  Future<void> _onSubmit() async {
    try {
      final location = await locationNotifier.getCurrentLocation();

      if (location != null) {
        appNavigator.pushAndReplace('/');
      }
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWidget(
      appBar: AppBar(
        title: Text(localizedString.getLocalizedString(
          'ask-location-screen.title',
        )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).primaryColor, width: 1),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Icon(Icons.location_on_sharp, size: 80),
              ),
              SizedBox(height: 48),
              Text(
                localizedString
                    .getLocalizedString('ask-location-screen.description'),
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                localizedString.getLocalizedString('ask-location-screen.body'),
                style: Theme.of(context).textTheme.subtitle1,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                child: Text(localizedString.getLocalizedString(
                  'ask-location-screen.submit-button',
                )),
                onPressed: _onSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
