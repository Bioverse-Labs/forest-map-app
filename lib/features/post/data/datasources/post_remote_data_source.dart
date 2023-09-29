import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/post_model.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import '../../../../core/adapters/firebase_storage_adapter.dart';
import '../../../../core/adapters/firestore_adapter.dart';
import '../../../../core/enums/exception_origin_types.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/util/localized_string.dart';
import '../../../../core/util/uuid_generator.dart';

abstract class PostRemoteDataSource {
  Future<void> savePost(PostModel post);
  Future<List<PostModel>> getPosts({required String? orgId});
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final FirestoreAdapterImpl? firestoreAdapter;
  final FirebasStorageAdapter? firebaseStorageAdapter;
  final LocalizedString? localizedString;
  final UUIDGenerator? uuidGenerator;

  PostRemoteDataSourceImpl({
    required this.firestoreAdapter,
    required this.firebaseStorageAdapter,
    required this.localizedString,
    required this.uuidGenerator,
  });

  @override
  Future<void> savePost(PostModel post) async {
    try {
      final file = File(post.imageUrl!);
      String? imageUrl;

      if (file.existsSync()) {
        await firebaseStorageAdapter!.uploadFile(
          file: File(post.imageUrl!),
          storagePath:
              'organizations/${post.organizationId}/posts/${post.id}.png',
        );
        imageUrl = await firebaseStorageAdapter!.getDownloadUrl(
            'organizations/${post.organizationId}/posts/${post.id}.png');
      }

      await firestoreAdapter!.addDocument(
        'organizations/${post.organizationId}/posts/${post.id}',
        {
          ...post.toMap(),
          'imageUrl': imageUrl,
        },
      );
    } on FirebaseException catch (error) {
      throw ServerException(
        localizedString!.getLocalizedString('generic-exception'),
        error.code,
        ExceptionOriginTypes.firebaseFirestore,
        stackTrace: error.stackTrace,
      );
    } catch (error) {
      throw ServerException(
        localizedString!.getLocalizedString('generic-exception'),
        '400',
        ExceptionOriginTypes.firebaseFirestore,
        // stackTrace: error.stackTrace,
      );
    }
  }

  @override
  Future<List<PostModel>> getPosts({String? orgId}) async {
    try {
      final query = firestoreAdapter!.firestore.collection(
        'organizations/$orgId/posts',
      );
      final res = await firestoreAdapter!.runQuery(query);

      if (res.isEmpty) return [];

      final posts = <PostModel>[];

      for (var doc in res) {
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          final docDir = (await getApplicationDocumentsDirectory()).path;
          final imgFile = File(joinAll([docDir, doc.id]));
          final imgUrl = data['imageUrl'];

          if (await imgFile.exists()) {
            await imgFile.delete();
          }

          if (imgUrl is String) {
            final imgData = await http.get(Uri.parse(imgUrl));
            await imgFile.create();
            await imgFile.writeAsBytes(imgData.bodyBytes);
          }

          posts.add(PostModel.fromMap(data).copyWith(imageUrl: imgFile.path));
        }
      }

      return posts;
    } on FirebaseException catch (error) {
      throw ServerException(
        error.message,
        error.code,
        ExceptionOriginTypes.firebaseFirestore,
        stackTrace: StackTrace.fromString(error.toString()),
      );
    } catch (error) {
      throw ServerException(
        localizedString!.getLocalizedString('generic-exception'),
        error.toString(),
        ExceptionOriginTypes.firebaseFirestore,
        stackTrace: StackTrace.fromString(error.toString()),
      );
    }
  }
}
