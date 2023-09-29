import 'dart:io';
import 'dart:ui';

import 'package:image/image.dart';

abstract class ImageUtils {
  File pathToFile(String path);
  Image? fileToImage(File file);
  Size getImageSize(Image? image);
}

class ImageUtilsImpl implements ImageUtils {
  @override
  Image? fileToImage(File? file) {
    assert(file != null);

    if (!file!.existsSync()) {
      throw Exception('file does not exists at path ${file.path}');
    }

    return decodeImage(file.readAsBytesSync());
  }

  @override
  File pathToFile(String? path) {
    assert(path != null);

    return File(path!);
  }

  @override
  Size getImageSize(Image? image) {
    assert(image != null);

    return Size(image!.width.toDouble(), image.height.toDouble());
  }
}
