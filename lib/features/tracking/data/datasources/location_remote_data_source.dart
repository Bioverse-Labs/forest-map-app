import 'package:firebase_core/firebase_core.dart';
import 'package:forest_map/core/adapters/firestore_adapter.dart';
import '../../../../core/enums/exception_origin_types.dart';
import '../../../../core/errors/exceptions.dart';

import '../../domain/entities/location.dart';
import '../models/location_model.dart';

abstract class LocationRemoteDataSource {
  /// save [Location] user's subcollection tracking in [Firestore]
  ///
  Future<void> saveLocation(
    String? userId,
    LocationModel location,
  );

  Future<List<LocationModel>> getLocations(String? userId);
}

class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  final FirestoreAdapter? firestoreAdapter;

  LocationRemoteDataSourceImpl({
    required this.firestoreAdapter,
  });

  @override
  Future<void> saveLocation(
    String? userId,
    LocationModel location,
  ) async {
    try {
      await firestoreAdapter!.addDocument(
        'users/$userId/tracking/${location.id}',
        location.toMap(),
      );
    } on FirebaseException catch (error) {
      throw ServerException(
        error.message,
        '500',
        ExceptionOriginTypes.firebaseFirestore,
      );
    }
  }

  @override
  Future<List<LocationModel>> getLocations(String? userId) async {
    try {
      final query = firestoreAdapter!.firestore
          .doc('users/$userId')
          .collection('tracking');

      final res = await firestoreAdapter!.runQuery(query);

      return res
          .map<LocationModel>(
            (doc) => LocationModel.fromMap(
              (doc.data() as Map<String, dynamic>),
            ),
          )
          .toList();
    } on FirebaseException catch (error) {
      throw ServerException(
        error.message,
        '500',
        ExceptionOriginTypes.firebaseFirestore,
      );
    }
  }
}
