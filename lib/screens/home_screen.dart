// import 'dart:async';

// import 'package:bot_toast/bot_toast.dart';
// import 'package:flutter/material.dart';
// import '../notifiers/data_notifier.dart';
// import '../core/navigation/app_navigator.dart';
// import '../widgets/home_drawer.dart';
// import 'package:get_it/get_it.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';

// class HomeScreen extends StatelessWidget {
//   HomeScreen({Key key}) : super(key: key);

//   final Completer<GoogleMapController> _controller = Completer();
//   final picker = ImagePicker();

//   final _initialPosition = CameraPosition(
//     target: LatLng(-3.4653052, -62.2246353),
//     zoom: 14.4746,
//   );

//   Future<void> _takePicture(BuildContext context) async {
//     BotToast.showLoading();
//     BotToast.closeAllLoading();
//     // Provider.of<DataNotifier>(context, listen: false).setImage(imgFile);
//     GetIt.I<AppNavigator>().push('/preview');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Forest Map App'),
//       ),
//       drawer: HomeDrawer(),
//       body: GoogleMap(
//         mapType: MapType.hybrid,
//         zoomControlsEnabled: true,
//         myLocationButtonEnabled: true,
//         myLocationEnabled: true,
//         initialCameraPosition: _initialPosition,
//         onMapCreated: (GoogleMapController controller) {
//           _controller.complete(controller);
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.camera_alt),
//         onPressed: () => _takePicture(context),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }
// }
