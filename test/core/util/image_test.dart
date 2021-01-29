import 'dart:io';
import 'dart:ui';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forestMapApp/core/util/image.dart';
import 'package:image/image.dart';
import 'package:http/http.dart' as httpClient;

import 'get_path.dart';

void main() {
  final tImageUrl = faker.image.image(
    width: 648,
    height: 480,
    keywords: ['tree', 'forest'],
  );
  final tSize = Size(648, 480);
  ImageUtilsImpl imageUtilsImpl;
  Image tImage;
  final tPath = getTestPath('test/core/util/test_file.jpeg');
  final tFile = File(tPath);

  setUp(() async {
    final imageResp = await httpClient.get(tImageUrl, headers: {
      'Content-Type': 'image/jpeg',
    });
    tImage = decodeImage(imageResp.bodyBytes);
    tFile.writeAsBytesSync(imageResp.bodyBytes);
    imageUtilsImpl = ImageUtilsImpl();
  });

  group('fileToImage', () {
    test('should return [Image] if file exists', () {
      final result = imageUtilsImpl.fileToImage(tFile);

      expect(result, isInstanceOf<Image>());
      expect(result.width, tSize.width);
      expect(result.height, tSize.height);
    });

    test('should throw [AssertionError] if file is null', () {
      final call = imageUtilsImpl.fileToImage;

      expect(() => call(null), throwsAssertionError);
    });

    test('should throw [Exception] if file does not exist', () {
      final call = imageUtilsImpl.fileToImage;

      expect(() => call(File('')), throwsException);
    });
  });

  group('pathToFile', () {
    test('should return [File] if path exists', () {
      final result = imageUtilsImpl.pathToFile(tPath);

      expect(result, isInstanceOf<File>());
      expect(result.existsSync(), true);
    });

    test('should throw [AssertionError] if path is null', () {
      final call = imageUtilsImpl.pathToFile;

      expect(() => call(null), throwsAssertionError);
    });
  });

  group('getImageSize', () {
    test('should return [Size] if Image exists', () {
      final result = imageUtilsImpl.getImageSize(tImage);

      expect(result.width, tSize.width);
      expect(result.height, tSize.height);
    });

    test('should throw [AssertionError] if Image is null', () {
      final call = imageUtilsImpl.getImageSize;

      expect(() => call(null), throwsAssertionError);
    });
  });
}
