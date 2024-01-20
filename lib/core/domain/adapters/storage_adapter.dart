import 'dart:io';

abstract class StorageAdapter {
  void uploadFile({File? file, String? storagePath});
  Future<String> getDownloadUrl(String storagePath);
}
