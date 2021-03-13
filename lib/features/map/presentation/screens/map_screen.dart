import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../../../../core/platform/camera.dart';
import '../../../../core/style/theme.dart';
import '../../../../core/util/localized_string.dart';
import '../../../../core/util/notifications.dart';
import '../../../../core/widgets/screen.dart';
import '../../../organization/presentation/notifiers/organizations_notifier.dart';
import '../../../post/presentation/notifier/post_notifier.dart';
import '../../../post/presentation/widgets/save_post_dialog.dart';
import '../../../tracking/domain/entities/location.dart';
import '../../../tracking/presentation/notifiers/location_notifier.dart';
import '../../../user/presentation/notifiers/user_notifier.dart';
import '../notifiers/map_notifier.dart';
import '../widgets/geolocation_loader.dart';

class MapScreen extends StatefulWidget {
  final LocalizedString localizedString;
  final LocationNotifierImpl locationNotifier;
  final UserNotifierImpl userNotifier;
  final PostNotifierImpl postNotifier;
  final OrganizationNotifierImpl organizationNotifier;
  final MapNotifierImpl mapNotifier;
  final NotificationsUtils notificationsUtils;
  final Camera camera;
  final AppNavigator appNavigator;
  final AppSettings appSettings;
  final AppTheme appTheme;

  MapScreen({
    Key key,
    @required this.localizedString,
    @required this.locationNotifier,
    @required this.userNotifier,
    @required this.postNotifier,
    @required this.notificationsUtils,
    @required this.appNavigator,
    @required this.appSettings,
    @required this.organizationNotifier,
    @required this.mapNotifier,
    @required this.camera,
    @required this.appTheme,
  }) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with WidgetsBindingObserver {
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _initalPosition;
  bool _shouldUpdateState = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed && _shouldUpdateState) {
      _shouldUpdateState = false;
      setState(() {});
    }
  }

  Future<void> _fetchLocation() async {
    try {
      await widget.locationNotifier.trackUser(widget.userNotifier.user.id);

      final location = await widget.locationNotifier.getCurrentLocation();
      _initalPosition = CameraPosition(
        target: LatLng(location.lat, location.lng),
        zoom: 16,
      );
    } on LocationFailure catch (failure) {
      return failure;
    } on LocalFailure catch (_) {
      widget.notificationsUtils.showErrorNotification(
        widget.localizedString.getLocalizedString('generic-exception'),
      );
    }
  }

  void _askPermission(BuildContext context) {
    widget.notificationsUtils.showAlertDialog(
      title: Text(
        widget.localizedString.getLocalizedString('map-screen.alert-title'),
      ),
      content: Text(
        widget.localizedString.getLocalizedString(
          'map-screen.alert-description',
        ),
      ),
      buttons: [
        AlertButtonParams(
          title: widget.localizedString.getLocalizedString(
            'map-screen.alert-cancel-button',
          ),
        ),
        AlertButtonParams(
          title: widget.localizedString.getLocalizedString(
            'map-screen.alert-confirm-button',
          ),
          action: () async {
            await AppSettings.openAppSettings();
            widget.appNavigator.pop();
            _shouldUpdateState = true;
          },
          isPrimary: true,
        ),
      ],
    );
  }

  void _handleMapCreation(GoogleMapController controller) {
    _controller.complete(controller);
  }

  Future<void> _updateMapPosition(Location location) async {
    if (location != null) {
      final position = CameraPosition(
        target: LatLng(location.lat, location.lng),
        zoom: 16,
      );

      final controllerFuture = await _controller.future;
      controllerFuture.animateCamera(CameraUpdate.newCameraPosition(position));
    }
  }

  Future<void> _savePost(String specie, CameraResponse cameraResponse) async {
    try {
      widget.notificationsUtils.showInfoNotification(
        widget.localizedString.getLocalizedString('map-screen.start-saving'),
      );
      await widget.postNotifier.savePost(
        file: cameraResponse.file,
        organizationId: widget.organizationNotifier?.organization?.id,
        userId: widget.userNotifier?.user?.id,
        specie: specie,
      );
      widget.notificationsUtils.showSuccessNotification(
        widget.localizedString.getLocalizedString('map-screen.post-success'),
      );
    } on ServerFailure catch (failure) {
      widget.notificationsUtils.showErrorNotification(failure.message);
    } on LocalFailure catch (failure) {
      widget.notificationsUtils.showErrorNotification(failure.message);
    } on LocationFailure catch (failure) {
      widget.notificationsUtils.showErrorNotification(failure.message);
    }
  }

  Future<void> _takePicture(BuildContext context) async {
    final failureOrCameraResp = await widget.camera.takePicture(isTemp: false);

    failureOrCameraResp.fold(
      (failure) {
        if (!(failure is CameraCancelFailure)) {
          widget.notificationsUtils.showErrorNotification(
            widget.localizedString.getLocalizedString('generic-exception'),
          );
        }
      },
      (cameraResp) => showDialog(
        context: context,
        builder: (ctx) => SavePostDialog(
          ctx: ctx,
          cameraResponse: cameraResp,
          appTheme: widget.appTheme,
          localizedString: widget.localizedString,
          onSave: (name) {
            widget.appNavigator.pop();
            _savePost(name, cameraResp);
          },
          onCancel: widget.appNavigator.pop,
        ),
      ),
    );
  }

  Future<void> _goToDataLocation() async {
    final position = CameraPosition(
      target: LatLng(-7.32419301411112, -51.746992841544795),
      zoom: 16,
    );

    final controllerFuture = await _controller.future;
    controllerFuture.animateCamera(CameraUpdate.newCameraPosition(position));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder(
          future: _fetchLocation(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.data is LocationFailure) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.localizedString.getLocalizedString(
                          'map-screen.location-permission-title',
                        ),
                        style: Theme.of(context).textTheme.headline5,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => _askPermission(context),
                        child: Text(widget.localizedString.getLocalizedString(
                          'map-screen.location-permission-button',
                        )),
                      )
                    ],
                  ),
                ),
              );
            }

            return ScreenWidget(
              body: Consumer<LocationNotifierImpl>(
                builder: (ctx, state, child) {
                  _updateMapPosition(state.currentLocation);

                  return child;
                },
                child: Consumer<OrganizationNotifierImpl>(
                  builder: (ctx, state, _) {
                    return GoogleMap(
                      initialCameraPosition: _initalPosition,
                      onMapCreated: _handleMapCreation,
                      myLocationEnabled: true,
                      mapType: MapType.satellite,
                      myLocationButtonEnabled: true,
                    );
                  },
                ),
              ),
              floatingActionButton: snapshot.data is LocationFailure
                  ? Container()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FloatingActionButton(
                          heroTag: 'mapPhotoActionButton',
                          onPressed: () => _takePicture(context),
                          child: Icon(Icons.add_a_photo_outlined),
                        ),
                        SizedBox(width: 8),
                        FloatingActionButton.extended(
                          heroTag: 'goToTreeButton',
                          onPressed: _goToDataLocation,
                          icon: Icon(Icons.gps_fixed_outlined),
                          label: Text('Data location'),
                        ),
                      ],
                    ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
            );
          },
        ),
        Positioned(
          top: 92,
          left: 16,
          right: 16,
          child: GeolocationLoader(
            organization: widget.organizationNotifier.organization,
            localizedString: widget.localizedString,
          ),
        ),
      ],
    );
  }
}
