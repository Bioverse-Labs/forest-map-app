import 'dart:io';
import 'package:path/path.dart' as path;

String getTestPath(String filePath) {
  var dir = Directory.current.path;
  if (dir.endsWith('/test')) {
    dir = dir.replaceAll('/test', '');
  }

  return path.join(dir, filePath);
}
