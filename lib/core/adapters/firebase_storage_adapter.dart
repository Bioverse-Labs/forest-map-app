import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:forest_map/core/adapters/storage_adapter.dart';

class FirebaseStorageAdapterImpl implements StorageAdapter {
  final FirebaseStorage? storage;

  FirebaseStorageAdapterImpl(this.storage);

  @override
  Future<String> getDownloadUrl(String storagePath) =>
      storage!.ref(storagePath).getDownloadURL();

  @override
  UploadTask uploadFile({File? file, String? storagePath}) {
    return storage!.ref(storagePath).putFile(file!);
  }
}
