import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/services.dart' show rootBundle;
import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
  Location _currentLocation;
  bool _shouldUpdateState = false;
  bool _hasPermission = true;
  MapType _mapType = MapType.satellite;
  BitmapDescriptor _pinLocationIcon;

  Set<Marker> _markers = Set<Marker>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _setCustomMapPin();
    _fetchLocation();
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

  Future<void> _setCustomMapPin() async {
    _pinLocationIcon = await _renderMarker(32);
  }

  Future<BitmapDescriptor> _renderMarker(int size) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final radius = size / 2;

    final imageData = await rootBundle.load('assets/marker_$size.png');
    final decodedImage =
        await decodeImageFromList(imageData.buffer.asUint8List());

    canvas.drawImage(
      decodedImage,
      Offset(0, 0),
      Paint(),
    );

    final image = await pictureRecorder.endRecording().toImage(
          radius.toInt() * 2,
          radius.toInt() * 2,
        );

    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }

  Future<void> _fetchLocation() async {
    try {
      await widget.locationNotifier.trackUser(widget.userNotifier.user.id);

      final location = await widget.locationNotifier.getCurrentLocation();
      _initalPosition = CameraPosition(
        target: LatLng(location.lat, location.lng),
        zoom: 14,
      );
      setState(() {});
    } on LocationFailure catch (_) {
      _hasPermission = true;
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
    if (location != null && location != _currentLocation) {
      final position = CameraPosition(
        target: LatLng(location.lat, location.lng),
        zoom: 14,
      );

      final controllerFuture = await _controller.future;
      controllerFuture.animateCamera(CameraUpdate.newCameraPosition(position));

      _currentLocation = location;
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
      target: LatLng(-7.78404597523145, -51.94507302669496),
      zoom: 14,
    );

    final controllerFuture = await _controller.future;
    controllerFuture.animateCamera(CameraUpdate.newCameraPosition(position));
  }

  void _onMapMoved(position) {
    widget.mapNotifier
        .getGeoData(
          organization: widget.organizationNotifier.organization,
          latitude: position.target.latitude,
          longitude: position.target.longitude,
        )
        .then(
          (failureOrData) => failureOrData.fold(
            (l) => null,
            (geoData) {
              if (mounted) {
                _markers.clear();

                for (var item in geoData) {
                  final marker = Marker(
                    markerId: MarkerId(item.id),
                    position: LatLng(item.latitude, item.longitude),
                    icon: _pinLocationIcon,
                    consumeTapEvents: true,
                    onTap: () => widget.notificationsUtils.showAlertDialog(
                      title: Text(item.specie),
                      content: Container(
                        height: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${item.type} - ${item.specie}'),
                            Divider(),
                            Text(
                              '${item.latitude} / ${item.longitude}',
                              style: TextStyle(fontSize: 12),
                            )
                          ],
                        ),
                      ),
                      buttons: [
                        AlertButtonParams(
                          title: 'OK',
                          isPrimary: true,
                        ),
                      ],
                    ),
                  );
                  _markers.add(marker);
                }

                setState(() {});
              }
            },
          ),
        );
  }

  void _changeMapType() {
    switch (_mapType) {
      case MapType.satellite:
        _mapType = MapType.terrain;
        break;
      case MapType.terrain:
        _mapType = MapType.hybrid;
        break;
      case MapType.hybrid:
        _mapType = MapType.normal;
        break;
      default:
        _mapType = MapType.satellite;
        break;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<LocationNotifierImpl, MapNotifierImpl>(
      builder: (ctx, locationState, mapState, _) {
        if (mounted) {
          _updateMapPosition(locationState.currentLocation);
        }

        if ((_initalPosition == null && _hasPermission) || mapState.isLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    widget.localizedString.getLocalizedString(
                        'map-screen.loading-geolocation-files'),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          );
        }

        if (!_hasPermission) {
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

        if (_initalPosition != null && _hasPermission) {
          return ScreenWidget(
            body: Stack(
              fit: StackFit.expand,
              children: [
                GoogleMap(
                  initialCameraPosition: _initalPosition,
                  onMapCreated: _handleMapCreation,
                  myLocationEnabled: true,
                  mapType: _mapType,
                  myLocationButtonEnabled: true,
                  markers: _markers,
                  onCameraMove: _onMapMoved,
                ),
                if (mapState.isQuerying)
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      width: 36,
                      height: 36,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.white,
                      ),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
              ],
            ),
            floatingActionButton: !_hasPermission
                ? Container()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton(
                        heroTag: 'mapPhotoActionButton',
                        onPressed: () => _takePicture(context),
                        child: Icon(Icons.add_a_photo_outlined),
                      ),
                      SizedBox(width: 16),
                      FloatingActionButton(
                          heroTag: 'goToDataLocation',
                          onPressed: _goToDataLocation,
                          child: Image.asset(
                            'assets/marker_128.png',
                          )),
                      SizedBox(width: 16),
                      FloatingActionButton(
                        heroTag: 'switchMapType',
                        onPressed: _changeMapType,
                        child: Icon(Icons.layers_outlined),
                      ),
                    ],
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
        }

        return Container();
      },
    );
  }
}
