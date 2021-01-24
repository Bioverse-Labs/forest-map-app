import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'notifications.dart';

class CameraUtils {
  static Future<File> takePicture() async {
    try {
      final pickerFile = await GetIt.I<ImagePicker>().getImage(
        source: ImageSource.camera,
        imageQuality: 50,
        preferredCameraDevice: CameraDevice.rear,
      );
      final appDir = (await getApplicationDocumentsDirectory()).path;
      final imgFile = await File(pickerFile?.path).copy(
        '$appDir/${DateTime.now().millisecond}',
      );

      return imgFile;
    } on PlatformException catch (err) {
      Notifications.showErrorNotification(err.message);
    } catch (err) {
      Notifications.showErrorNotification(err.toString());
    }

    return null;
  }
}
