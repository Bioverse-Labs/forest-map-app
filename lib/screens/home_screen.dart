import 'dart:async';

import 'package:flutter/material.dart';
import 'package:forestMapApp/widgets/home_drawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key key}) : super(key: key);

  final Completer<GoogleMapController> _controller = Completer();
  final picker = ImagePicker();

  final _initialPosition = CameraPosition(
    target: LatLng(-3.4653052, -62.2246353),
    zoom: 14.4746,
  );

  Future<void> _takePicture() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forest Map App'),
      ),
      drawer: HomeDrawer(),
      body: GoogleMap(
        mapType: MapType.hybrid,
        zoomControlsEnabled: true,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        initialCameraPosition: _initialPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: _takePicture,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
