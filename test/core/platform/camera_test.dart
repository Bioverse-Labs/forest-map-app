import 'dart:io';
import 'dart:ui';

import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:forestMapApp/core/errors/failure.dart';
import 'package:forestMapApp/core/platform/camera.dart';
import 'package:forestMapApp/core/util/image.dart';
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as httpClient;

import '../util/get_path.dart';

class MockImagePicker extends Mock implements ImagePicker {}

class MockPickedFile extends Mock implements PickedFile {}

class MockImageUtils extends Mock implements ImageUtils {}

void main() {
  MockImagePicker mockImagePicker;
  MockPickedFile mockPickedFile;
  MockImageUtils mockImageUtils;
  CameraImpl cameraImpl;

  setUp(() {
    mockImagePicker = MockImagePicker();
    mockPickedFile = MockPickedFile();
    mockImageUtils = MockImageUtils();
    cameraImpl = CameraImpl(mockImagePicker, mockImageUtils);
  });

  final tImageUrl = faker.image.image(
    width: 648,
    height: 480,
    keywords: ['tree', 'forest'],
  );
  final tPath = getTestPath('test/core/platform/test_file.jpeg');
  final tFile = File(tPath);
  final tSize = Size(648, 480);
  Image tImage;

  group('takePicture', () {
    setUp(() async {
      final imageResp = await httpClient.get(tImageUrl, headers: {
        'Content-Type': 'image/jpeg',
      });
      tImage = decodeImage(imageResp.bodyBytes);
      tFile.writeAsBytesSync(imageResp.bodyBytes);
      when(mockPickedFile.path).thenReturn(tPath);
      when(mockImageUtils.pathToFile(any)).thenReturn(tFile);
      when(mockImageUtils.fileToImage(any)).thenReturn(tImage);
      when(mockImageUtils.getImageSize(any)).thenReturn(tSize);
    });

    test(
      'should return [CameraResponse] when picture is successfuly taken',
      () async {
        when(mockImagePicker.getImage(
          source: anyNamed('source'),
          imageQuality: anyNamed('imageQuality'),
        )).thenAnswer((_) async => mockPickedFile);

        final tCameraResponse = CameraResponse(
          file: tFile,
          path: tPath,
          image: tImage,
          size: tSize,
          quality: 100,
          source: ImageSource.camera,
        );

        final result = await cameraImpl.takePicture();

        expect(result, equals(Right(tCameraResponse)));
        verify(mockImagePicker.getImage(
          source: ImageSource.camera,
          imageQuality: 100,
        ));
        verifyNoMoreInteractions(mockImagePicker);
      },
    );

    test(
      'should return [CameraCancelFailure] when user cancel picture',
      () async {
        when(mockImagePicker.getImage(
          source: anyNamed('source'),
          imageQuality: anyNamed('imageQuality'),
        )).thenAnswer((_) async => null);

        final result = await cameraImpl.takePicture();

        expect(result, equals(Left(CameraCancelFailure())));
        verify(mockImagePicker.getImage(
          source: ImageSource.camera,
          imageQuality: 100,
        ));
        verifyNoMoreInteractions(mockImagePicker);
      },
    );

    test(
      'should return [CameraFailure] if any exception is throw',
      () async {
        when(mockImagePicker.getImage(
          source: anyNamed('source'),
          imageQuality: anyNamed('imageQuality'),
        )).thenThrow(Exception());

        final result = await cameraImpl.takePicture();

        expect(result, equals(Left(CameraFailure())));
        verify(mockImagePicker.getImage(
          source: ImageSource.camera,
          imageQuality: 100,
        ));
        verifyNoMoreInteractions(mockImagePicker);
      },
    );
  });
}
