import 'dart:io';

import 'package:path_provider/path_provider.dart';

class DirUtils {
  Future<Directory> getDocumentsDirectory() async =>
      getApplicationDocumentsDirectory();
  Future<Directory> getTempDirectory() async => getTemporaryDirectory();
}
