import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

abstract class FirebasStorageAdapter {
  Future<UploadTask> uploadFile({File file, String storagePath});
  Future<String> getDownloadUrl(String storagePath);
}

class FirebaseStorageAdapterImpl implements FirebasStorageAdapter {
  final FirebaseStorage storage;

  FirebaseStorageAdapterImpl(this.storage);

  @override
  Future<String> getDownloadUrl(String storagePath) =>
      storage.ref(storagePath).getDownloadURL();

  @override
  Future<UploadTask> uploadFile({File file, String storagePath}) {
    return Future.value(storage.ref(storagePath).putFile(file));
  }
}
