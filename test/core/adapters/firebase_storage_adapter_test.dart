import 'dart:io';

import 'package:faker/faker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:forest_map_app/core/adapters/firebase_storage_adapter.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockFirebaseStorage extends Mock implements FirebaseStorage {}

class MockUploadTask extends Mock implements UploadTask {}

class MockReference extends Mock implements Reference {}

void main() {
  MockFirebaseStorage mockFirebaseStorage;
  MockUploadTask mockUploadTask;
  MockReference mockReference;
  FirebaseStorageAdapterImpl firebaseStorageAdapterImpl;

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
