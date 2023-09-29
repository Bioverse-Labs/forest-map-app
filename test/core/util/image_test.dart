import 'dart:io';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:forest_map/core/util/image.dart';
import 'package:image/image.dart';

import 'get_path.dart';

void main() {
  final tSize = Size(648, 480);
  final tPath = getTestPath('test/core/util/test_file.jpeg');
  final tFile = File(tPath);
  final tImage = decodeImage(tFile.readAsBytesSync());
  late ImageUtilsImpl imageUtilsImpl;

  setUp(() async {
    imageUtilsImpl = ImageUtilsImpl();
  });

  group('fileToImage', () {
    test('should return [Image] if file exists', () {
      final result = imageUtilsImpl.fileToImage(tFile);

      expect(result, isInstanceOf<Image>());
      expect(result?.width, tSize.width);
      expect(result?.height, tSize.height);
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
