import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

abstract class StorageAdapter {
  UploadTask uploadFile({File? file, String? storagePath});
  Future<String> getDownloadUrl(String storagePath);
}
