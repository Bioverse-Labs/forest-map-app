import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:meta/meta.dart';

import '../../../../core/adapters/firebase_storage_adapter.dart';
import '../../../../core/adapters/firestore_adapter.dart';
import '../../../../core/enums/exception_origin_types.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/util/localized_string.dart';
import '../../../../core/util/uuid_generator.dart';
import '../../../tracking/data/models/location_model.dart';
import '../../../tracking/domain/entities/location.dart';

abstract class PostRemoteDataSource {
  Future<void> savePost({
    String organizationId,
    String userId,
    String specie,
    File file,
    Location location,
  });
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final FirestoreAdapter firestoreAdapter;
  final FirebasStorageAdapter firebaseStorageAdapter;
  final LocalizedString localizedString;
  final UUIDGenerator uuidGenerator;

  PostRemoteDataSourceImpl({
    @required this.firestoreAdapter,
    @required this.firebaseStorageAdapter,
    @required this.localizedString,
    @required this.uuidGenerator,
  });

  @override
  Future<void> savePost({
    @required String organizationId,
    @required String userId,
    @required String specie,
    @required File file,
    @required Location location,
  }) async {
    try {
      final timeStamp = DateTime.now();
      final id = uuidGenerator.generateUID();

      await firebaseStorageAdapter.uploadFile(
        file: file,
        storagePath: 'organizations/$organizationId/posts/$id.png',
      );
      final imageUrl = await firebaseStorageAdapter.getDownloadUrl(
        'organizations/$organizationId/posts/$id.png',
      );

      await firestoreAdapter.addDocument(
        'organizations/$organizationId/posts/$id',
        {
          ...LocationModel.fromEntity(location).toMap(),
          'id': id,
          'userId': userId,
          'specie': specie,
          'timestamp': timeStamp,
          'imageUrl': imageUrl,
        },
      );
    } on FirebaseException catch (error) {
      throw ServerException(
        localizedString.getLocalizedString('generic-exception'),
        error.code,
        ExceptionOriginTypes.firebaseFirestore,
        stackTrace: error.stackTrace,
      );
    } catch (error) {
      throw ServerException(
        localizedString.getLocalizedString('generic-exception'),
        error.code,
        ExceptionOriginTypes.firebaseFirestore,
        stackTrace: error.stackTrace,
      );
    }
  }
}
