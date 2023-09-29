import 'dart:io';

import 'package:faker/faker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:forest_map/core/adapters/firebase_storage_adapter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'firebase_storage_adapter_test.mocks.dart';

@GenerateMocks([
  FirebaseStorage,
  Reference,
  UploadTask,
])
void main() {
  late MockFirebaseStorage mockFirebaseStorage;
  late MockUploadTask mockUploadTask;
  late MockReference mockReference;
  late FirebaseStorageAdapterImpl firebaseStorageAdapterImpl;

  setUp(() {
    mockFirebaseStorage = MockFirebaseStorage();
    mockUploadTask = MockUploadTask();
    mockReference = MockReference();
    firebaseStorageAdapterImpl = FirebaseStorageAdapterImpl(
      mockFirebaseStorage,
    );
  });

  final tId = faker.guid.guid();
  final tFile = File(faker.image.image());

  group('Firebase Storage Adapter', () {
    setUp(() {
      when(mockFirebaseStorage.ref(any)).thenReturn(mockReference);
    });
    test(
      'should return [UploadTask] from file upload',
      () async {
        when(mockReference.putFile(any)).thenAnswer((_) => mockUploadTask);

        final result = firebaseStorageAdapterImpl.uploadFile(
          file: tFile,
          storagePath: 'users/$tId',
        );

        expect(result, mockUploadTask);
        verify(mockFirebaseStorage.ref('users/$tId'));
        verify(mockReference.putFile(tFile));
        verifyNoMoreInteractions(mockFirebaseStorage);
      },
    );

    test(
      'should return [String] with donwloadUrl from given path',
      () async {
        when(mockReference.getDownloadURL())
            .thenAnswer((_) async => tFile.path);

        final result =
            await firebaseStorageAdapterImpl.getDownloadUrl('users/$tId');

        expect(result, tFile.path);
        verify(mockFirebaseStorage.ref('users/$tId'));
        verify(mockReference.getDownloadURL());
        verifyNoMoreInteractions(mockFirebaseStorage);
      },
    );
  });
}
