import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:forestMapApp/core/adapters/http_adapter.dart';
import 'package:forestMapApp/features/map/data/models/geolocation_data_model.dart';
import 'package:forestMapApp/features/map/data/models/geolocation_data_properties_model.dart';
import 'package:forestMapApp/features/organization/data/datasources/organization_remote_data_source.dart';
import 'package:geojson/geojson.dart';
import 'package:meta/meta.dart';

import '../../../../core/adapters/firebase_storage_adapter.dart';
import '../../../../core/adapters/firestore_adapter.dart';
import '../../../../core/enums/exception_origin_types.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/util/dir.dart';
import '../../../../core/util/geojson.dart';
import '../../../../core/util/localized_string.dart';
import '../../../organization/data/models/member_model.dart';
import '../../../organization/data/models/organization_model.dart';
import '../../../organization/domain/entities/organization.dart';
import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> getUser(String id);
  Future<UserModel> updateUser({
    @required String id,
    String name,
    String email,
    List<Organization> organizations,
    File avatar,
  });
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirestoreAdapterImpl firestoreAdapter;
  final FirebaseStorageAdapterImpl firebaseStorageAdapter;
  final LocalizedString localizedString;
  final OrganizationRemoteDataSource organizationRemoteDataSource;

  UserRemoteDataSourceImpl({
    @required this.firestoreAdapter,
    @required this.firebaseStorageAdapter,
    @required this.localizedString,
    @required this.organizationRemoteDataSource,
  });

  @override
  Future<UserModel> getUser(String id) async {
    try {
      final userDoc = await firestoreAdapter.getDocument('users/$id');
      final organizations = <OrganizationModel>[];
      if (!userDoc.exists) {
        throw ServerException(
          localizedString.getLocalizedString('database-exceptions.get-error'),
          '404',
          ExceptionOriginTypes.firebaseFirestore,
        );
      }

      for (var orgId in userDoc.data()['organizations'] ?? []) {
        final organization = await organizationRemoteDataSource.getOrganization(
          orgId,
        );
        organizations.add(organization);
      }

      return UserModel.fromMap({
        ...userDoc.data(),
        'organizations': organizations,
      });
    } on FirebaseException catch (error) {
      throw ServerException(
        localizedString.getLocalizedString('database-exceptions.get-error'),
        error.code,
        ExceptionOriginTypes.firebaseFirestore,
        stackTrace: error.stackTrace,
      );
    }
  }

  @override
  Future<UserModel> updateUser({
    String id,
    String name,
    String email,
    List<Organization> organizations,
    File avatar,
  }) async {
    try {
      final payload = <String, dynamic>{};

      if (name != null) {
        payload['name'] = name;
      }

      if (email != null) {
        payload['email'] = email;
      }

      if (organizations != null) {
        payload['organizations'] = organizations.map((e) => e.id).toList();
      }

      if (avatar != null) {
        await firebaseStorageAdapter.uploadFile(
          storagePath: 'users/$id/avatar/avatar.png',
          file: avatar,
        );
        final avatarUrl = await firebaseStorageAdapter.getDownloadUrl(
          'users/$id/avatar/avatar.png',
        );
        payload['avatarUrl'] = avatarUrl;
      }

      await firestoreAdapter.updateDocument('users/$id', payload);
      final userDoc = await firestoreAdapter.getDocument('users/$id');

      if (!userDoc.exists) {
        throw ServerException(
          localizedString.getLocalizedString('database-exceptions.get-error'),
          '404',
          ExceptionOriginTypes.firebaseFirestore,
        );
      }

      final _organizations = <OrganizationModel>[];
      for (var orgId in userDoc.data()['organizations']) {
        final organization = await organizationRemoteDataSource.getOrganization(
          orgId,
        );
        _organizations.add(organization);
      }

      return UserModel.fromMap({
        ...userDoc.data(),
        'organizations': _organizations,
      });
    } on FirebaseException catch (error) {
      throw ServerException(
        localizedString.getLocalizedString('database-exceptions.get-error'),
        error.code,
        ExceptionOriginTypes.firebaseFirestore,
        stackTrace: error.stackTrace,
      );
    }
  }
}
