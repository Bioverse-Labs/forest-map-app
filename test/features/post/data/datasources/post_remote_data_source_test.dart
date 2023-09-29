import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forest_map/core/adapters/firebase_storage_adapter.dart';
import 'package:forest_map/core/adapters/firestore_adapter.dart';
import 'package:forest_map/core/errors/exceptions.dart';
import 'package:forest_map/core/util/localized_string.dart';
import 'package:forest_map/core/util/uuid_generator.dart';
import 'package:forest_map/features/post/data/datasources/post_remote_data_source.dart';
import 'package:forest_map/features/post/data/models/post_model.dart';
import 'package:forest_map/features/tracking/data/models/location_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'post_remote_data_source_test.mocks.dart';

const String kTemporaryPath = 'temporaryPath';
const String kApplicationSupportPath = 'applicationSupportPath';
const String kDownloadsPath = 'downloadsPath';
const String kLibraryPath = 'libraryPath';
const String kApplicationDocumentsPath = '';
const String kExternalCachePath = 'externalCachePath';
const String kExternalStoragePath = 'externalStoragePath';

class MockPathProviderPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  Future<String> getTemporaryPath() async {
    return kTemporaryPath;
  }

  Future<String> getApplicationSupportPath() async {
    return kApplicationSupportPath;
  }

  Future<String> getLibraryPath() async {
    return kLibraryPath;
  }

  Future<String> getApplicationDocumentsPath() async {
    return kApplicationDocumentsPath;
  }

  Future<String> getExternalStoragePath() async {
    return kExternalStoragePath;
  }

  Future<List<String>> getExternalCachePaths() async {
    return <String>[kExternalCachePath];
  }

  Future<List<String>> getExternalStoragePaths({
    StorageDirectory? type,
  }) async {
    return <String>[kExternalStoragePath];
  }

  Future<String> getDownloadsPath() async {
    return kDownloadsPath;
  }
}

@GenerateMocks([
  FirestoreAdapterImpl,
  FirebasStorageAdapter,
  LocalizedString,
  UUIDGenerator,
  UploadTask,
  DocumentReference,
  CollectionReference,
  FirebaseFirestore,
], customMocks: [
  MockSpec<QueryDocumentSnapshot<Map<String, dynamic>>>(
    as: #MockQueryDocumentSnapshot,
  ),
])
void main() {
  late MockFirestoreAdapterImpl mockFirestoreAdapter;
  late MockFirebasStorageAdapter mockFirebaseStorage;
  late MockLocalizedString mockLocalizedString;
  late MockUUIDGenerator mockUUIDGenerator;
  late PostRemoteDataSourceImpl postRemoteDataSourceImpl;
  late MockCollectionReference<Map<String, dynamic>> mockCollectionReference;
  late MockQueryDocumentSnapshot mockQueryDocumentSnapshot;
  late MockFirebaseFirestore mockFirebaseFirestore;

  setUp(() {
    mockFirestoreAdapter = MockFirestoreAdapterImpl();
    mockFirebaseStorage = MockFirebasStorageAdapter();
    mockLocalizedString = MockLocalizedString();
    mockUUIDGenerator = MockUUIDGenerator();
    mockCollectionReference = MockCollectionReference();
    mockQueryDocumentSnapshot = MockQueryDocumentSnapshot();
    mockFirebaseFirestore = MockFirebaseFirestore();
    postRemoteDataSourceImpl = PostRemoteDataSourceImpl(
      firestoreAdapter: mockFirestoreAdapter,
      firebaseStorageAdapter: mockFirebaseStorage,
      localizedString: mockLocalizedString,
      uuidGenerator: mockUUIDGenerator,
    );

    PathProviderPlatform.instance = MockPathProviderPlatform();

    when(mockLocalizedString.getLocalizedString(any)).thenReturn(
      faker.randomGenerator.string(20),
    );
    when(mockFirebaseStorage.uploadFile(
      file: anyNamed('file'),
      storagePath: anyNamed('storagePath'),
    )).thenAnswer((_) => MockUploadTask());
  });

  final tUserId = faker.guid.guid();
  final tOrgId = faker.guid.guid();
  final tImageUrl = faker.image.image();
  final tFile = File(tImageUrl);
  final tLocation = LocationModel(
    id: faker.guid.guid(),
    lat: faker.randomGenerator.decimal(),
    lng: faker.randomGenerator.decimal(),
    timestamp: DateTime.now(),
  );
  final tPostId = faker.guid.guid();
  final tFirebaseException = FirebaseException(
    plugin: 'firestore',
    message: faker.randomGenerator.string(20),
  );

  group('savePost', () {
    test(
      'should save [Post]',
      () async {
        when(mockFirebaseStorage.getDownloadUrl(any)).thenAnswer(
          (_) async => tImageUrl,
        );
        when(mockUUIDGenerator.generateUID()).thenReturn(tPostId);

        when(mockFirestoreAdapter.addDocument(any, any))
            .thenAnswer((_) async => MockDocumentReference());

        await postRemoteDataSourceImpl.savePost(
          PostModel(
            id: tPostId,
            imageUrl: tFile.path,
            timestamp: tLocation.timestamp,
            location: tLocation,
            userId: tUserId,
            organizationId: tOrgId,
          ),
        );

        verifyNoMoreInteractions(mockFirebaseStorage);
      },
    );

    test(
      'should throw [ServerException] if adapter fails',
      () async {
        when(mockFirebaseStorage.getDownloadUrl(any)).thenAnswer(
          (_) async => tImageUrl,
        );
        when(mockUUIDGenerator.generateUID()).thenReturn(tPostId);

        when(mockFirestoreAdapter.addDocument(any, any)).thenThrow(
          tFirebaseException,
        );

        try {
          await postRemoteDataSourceImpl.savePost(
            PostModel(
              id: tPostId,
              imageUrl: tFile.path,
              timestamp: tLocation.timestamp,
              location: tLocation,
              userId: tUserId,
              organizationId: tOrgId,
            ),
          );
        } catch (error) {
          expect(
            error,
            isInstanceOf<ServerException>(),
          );
        }

        verifyNever(mockFirebaseStorage.getDownloadUrl(
          'organizations/$tOrgId/posts/$tPostId.png',
        ));
        verifyNever(mockFirebaseStorage.uploadFile(
          file: tFile,
          storagePath: 'organizations/$tOrgId/posts/$tPostId.png',
        ));
        verifyNoMoreInteractions(mockFirebaseStorage);
      },
    );
  });

  group('getPosts', () {
    test(
      'should get [Posts]',
      () async {
        when(mockFirestoreAdapter.firestore).thenReturn(mockFirebaseFirestore);
        when(mockFirebaseFirestore.collection(any))
            .thenReturn(mockCollectionReference);
        when(mockFirestoreAdapter.runQuery(any))
            .thenAnswer((_) async => [mockQueryDocumentSnapshot]);
        when(mockQueryDocumentSnapshot.exists).thenReturn(true);
        when(mockQueryDocumentSnapshot.id).thenReturn(tPostId);
        when(mockQueryDocumentSnapshot.data()).thenReturn(
          PostModel(
            id: tPostId,
            imageUrl: tImageUrl,
            timestamp: tLocation.timestamp,
            location: tLocation,
            userId: tUserId,
            organizationId: tOrgId,
          ).toMap(),
        );

        final result = await postRemoteDataSourceImpl.getPosts(
          orgId: tOrgId,
        );

        expect(result, isA<List<PostModel>>());
        verify(mockFirestoreAdapter.runQuery(any));
      },
    );

    test(
      'should throw [ServerException] if adapter fails',
      () async {
        when(mockFirebaseStorage.getDownloadUrl(any)).thenAnswer(
          (_) async => tImageUrl,
        );
        when(mockUUIDGenerator.generateUID()).thenReturn(tPostId);

        when(mockFirestoreAdapter.addDocument(any, any)).thenThrow(
          tFirebaseException,
        );

        try {
          await postRemoteDataSourceImpl.savePost(
            PostModel(
              id: tPostId,
              imageUrl: tFile.path,
              timestamp: tLocation.timestamp,
              location: tLocation,
              userId: tUserId,
              organizationId: tOrgId,
            ),
          );
        } catch (error) {
          expect(
            error,
            isInstanceOf<ServerException>(),
          );
        }

        verifyNever(mockFirebaseStorage.getDownloadUrl(
          'organizations/$tOrgId/posts/$tPostId.png',
        ));
        verifyNever(mockFirebaseStorage.uploadFile(
          file: tFile,
          storagePath: 'organizations/$tOrgId/posts/$tPostId.png',
        ));
        verifyNoMoreInteractions(mockFirebaseStorage);
      },
    );
  });
}
