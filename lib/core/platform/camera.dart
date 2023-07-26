import 'dart:io';
import 'dart:ui';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path_provider/path_provider.dart';

import '../errors/failure.dart';
import '../util/image.dart';

abstract class Camera {
  Future<Either<Failure, CameraResponse>> takePicture({
    bool? isTemp,
    int? quality,
    ImageSource? source,
  });
}

class CameraResponse extends Equatable {
  final File file;
  final Image? image;
  final String path;
  final Size size;
  final int? quality;
  final ImageSource? source;

  CameraResponse({
    required this.file,
    required this.image,
    required this.path,
    required this.size,
    required this.quality,
    required this.source,
  });

  @override
  List<Object?> get props => [file, image, path, size, quality, source];
}

class CameraImpl implements Camera {
  final ImagePicker? imagePicker;
  final ImageUtils? imageUtils;

  CameraImpl(this.imagePicker, this.imageUtils);

  @override
  Future<Either<Failure, CameraResponse>> takePicture({
    bool? isTemp = true,
    int? quality = 100,
    ImageSource? source = ImageSource.camera,
  }) async {
    try {
      final pFile =
          await imagePicker!.pickImage(source: source!, imageQuality: quality);

      if (pFile == null) {
        return Left(CameraCancelFailure());
      }

      File file = imageUtils!.pathToFile(pFile.path);
      final image = imageUtils!.fileToImage(file);
      final size = imageUtils!.getImageSize(image);

      if (!isTemp!) {
        final appDir = (await getApplicationDocumentsDirectory()).path;
        final date = DateTime.now().toIso8601String();
        file = await file.copy('$appDir/$date.jpeg');
      }

      return Right(CameraResponse(
        file: file,
        image: image,
        path: file.path,
        size: size,
        quality: quality,
        source: source,
      ));
    } catch (_) {
      return Left(CameraFailure());
    }
  }
}
