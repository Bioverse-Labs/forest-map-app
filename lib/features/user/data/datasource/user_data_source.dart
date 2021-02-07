import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:forestMapApp/core/adapters/firebase_storage_adapter.dart';
import 'package:forestMapApp/features/organization/data/models/organization_model.dart';
import 'package:meta/meta.dart';

import '../../../../core/adapters/firestore_adapter.dart';
import '../../../../core/enums/exception_origin_types.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/util/localized_string.dart';
import '../../../organization/data/models/member_model.dart';
import '../../../organization/domain/entities/organization.dart';
import '../models/user_model.dart';

abstract class UserDataSource {
  Future<UserModel> getUser(String id);
  Future<UserModel> updateUser({
    @required String id,
    String name,
    String email,
    List<Organization> organizations,
    File avatar,
  });
}

class UserDataSourceImpl implements UserDataSource {
  final FirestoreAdapterImpl firestoreAdapter;
  final FirebaseStorageAdapterImpl firebaseStorageAdapter;
  final LocalizedString localizedString;

  UserDataSourceImpl({
    @required this.firestoreAdapter,
    @required this.firebaseStorageAdapter,
    @required this.localizedString,
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

      for (var orgId in userDoc.data()['organizations']) {
        final organization = await _getOrganizations(orgId);
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
        final organization = await _getOrganizations(orgId);
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

  Future<OrganizationModel> _getOrganizations(String id) async {
    final orgDoc = await firestoreAdapter.getDocument('organizations/$id');

    if (orgDoc.exists) {
      final members = await _getMembers(id);

      return OrganizationModel.fromMap({
        ...orgDoc.data(),
        'members': members,
      });
    }

    return null;
  }

  Future<List<MemberModel>> _getMembers(String id) async {
    List<MemberModel> members = <MemberModel>[];

    final membersQuery = firestoreAdapter.firestore.collection(
      'organizations/$id/members',
    );
    final membersDoc = await firestoreAdapter.runQuery(membersQuery);
    if (membersDoc.isNotEmpty) {
      for (var member in membersDoc) {
        final userId = member.id;
        final userDoc = await firestoreAdapter.getDocument('users/$userId');

        if (userDoc.exists) {
          members.add(MemberModel.fromMap({
            ...userDoc.data(),
            ...member.data(),
          }));
        }
      }
    }

    return members;
  }
}
