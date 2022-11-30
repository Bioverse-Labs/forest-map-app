import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../../../core/adapters/firebase_storage_adapter.dart';
import '../../../../core/adapters/firestore_adapter.dart';
import '../../../../core/enums/exception_origin_types.dart';
import '../../../../core/enums/organization_member_status.dart';
import '../../../../core/enums/organization_role_types.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/util/localized_string.dart';
import '../../../../core/util/uuid_generator.dart';
import '../../../user/data/models/user_model.dart';
import '../../../user/domain/entities/user.dart';
import '../models/member_model.dart';
import '../models/organization_model.dart';

abstract class OrganizationRemoteDataSource {
  /// creates new organization into organizations collection and adds
  /// user passed as params as [owner] of this new organization then
  /// adds an organization reference inside user [Document].
  Future<OrganizationModel> createOrganization({
    @required UserModel user,
    @required String name,
    @required String email,
    @required String phone,
    File avatar,
  });

  /// return [Document] that matches [id] inside organizations
  /// collection
  Future<OrganizationModel> getOrganization(String id);

  /// update [Document] data that matches [id] inside organizations
  /// collection
  Future<OrganizationModel> updateOrganization({
    @required String id,
    @required String name,
    @required String email,
    @required String phone,
    File avatar,
  });

  /// remove [Document] from organizations collections that match [id]
  Future<void> deleteOrganization(String id);

  Future<OrganizationModel> addMember({
    @required String id,
    @required UserModel user,
  });

  /// remove user from organization and remove organization reference from
  /// [User] document
  Future<OrganizationModel> removeMember({
    @required String id,
    @required String userId,
  });

  Future<OrganizationModel> updateMember({
    @required String id,
    @required String userId,
    OrganizationRoleType role,
    OrganizationMemberStatus status,
  });
}

class OrganizationRemoteDataSourceImpl implements OrganizationRemoteDataSource {
  final FirestoreAdapterImpl firestoreAdapter;
  final FirebaseStorageAdapterImpl firebaseStorageAdapter;
  final LocalizedString localizedString;
  final UUIDGenerator uuidGenerator;

  OrganizationRemoteDataSourceImpl({
    @required this.firestoreAdapter,
    @required this.firebaseStorageAdapter,
    @required this.localizedString,
    @required this.uuidGenerator,
  });

  @override
  Future<OrganizationModel> createOrganization({
    UserModel user,
    String name,
    String email,
    String phone,
    File avatar,
  }) async {
    try {
      final orgId = uuidGenerator.generateUID();
      var avatarUrl;

      if (avatar != null) {
        await firebaseStorageAdapter.uploadFile(
          file: avatar,
          storagePath: 'organizations/$orgId/avatar/avatar.png',
        );
        avatarUrl = await firebaseStorageAdapter.getDownloadUrl(
          'organizations/$orgId/avatar/avatar.png',
        );
      }

      await firestoreAdapter.addDocument(
        'organizations/$orgId',
        {
          'id': orgId,
          'name': name,
          'email': email,
          'phone': phone,
          'avatarUrl': avatarUrl,
        },
      );
      await firestoreAdapter.addDocument(
        'organizations/$orgId/members/${user.id}',
        {
          'id': user.id,
          'status': OrganizationMemberStatus.active.index,
          'role': OrganizationRoleType.owner.index,
        },
      );

      await firestoreAdapter.updateDocument(
        'users/${user.id}',
        {
          'organizations': [
            ...(user?.organizations != null
                ? user?.organizations?.map((e) => e.id)?.toList()
                : []),
            orgId,
          ]
        },
      );

      return OrganizationModel(
        id: orgId,
        name: name,
        email: email,
        phone: phone,
        avatarUrl: avatarUrl,
        members: [
          MemberModel.fromMap({
            ...user.toMap(),
            'status': OrganizationMemberStatus.active.index,
            'role': OrganizationRoleType.owner.index,
          })
        ],
      );
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
  Future<void> deleteOrganization(String id) async {
    try {
      await firestoreAdapter.deleteDocument('organizations/$id');
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
  Future<OrganizationModel> getOrganization(String id) async {
    try {
      final orgDoc = await firestoreAdapter.getDocument('organizations/$id');

      if (!orgDoc.exists) {
        throw ServerException(
          localizedString.getLocalizedString('database-exceptions.get-error'),
          '404',
          ExceptionOriginTypes.firebaseFirestore,
        );
      }

      final orgData = orgDoc.data() as Map<String, dynamic>;

      return OrganizationModel.fromMap({
        ...orgData,
        'geolocationData': orgData['geolocationData']
            .map<String>((e) => e.toString())
            .toList(),
        'members': await _getMembers(id),
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
  Future<OrganizationModel> addMember({String id, User user}) async {
    try {
      final orgDoc = await firestoreAdapter.getDocument('organizations/$id');

      if (!orgDoc.exists) {
        throw ServerException(
          localizedString.getLocalizedString('database-exceptions.get-error'),
          '404',
          ExceptionOriginTypes.firebaseFirestore,
        );
      }

      await firestoreAdapter.addDocument(
        'organizations/$id/members/${user.id}',
        {
          'id': user.id,
          'status': OrganizationMemberStatus.active.index,
          'role': OrganizationRoleType.member.index,
        },
      );

      await firestoreAdapter.updateDocument(
        'users/${user.id}',
        {
          'organizations': [
            ...(user?.organizations != null
                ? user?.organizations?.map((e) => e.id)?.toList()
                : []),
            id,
          ]
        },
      );

      return getOrganization(id);
    } on FirebaseException catch (error) {
      throw ServerException(
        localizedString.getLocalizedString('database-exceptions.update-error'),
        error.code,
        ExceptionOriginTypes.firebaseFirestore,
        stackTrace: error.stackTrace,
      );
    }
  }

  @override
  Future<OrganizationModel> removeMember({
    @required String id,
    @required String userId,
  }) async {
    try {
      await firestoreAdapter.deleteDocument(
        'organizations/$id/members/$userId',
      );

      final userDoc = await firestoreAdapter.getDocument('users/$userId');
      if (userDoc.exists) {
        final List<String> organizations =
            (userDoc.data() as Map<String, dynamic>)['organizations']
                ?.map<String>((e) => e.toString())
                ?.toList();
        organizations?.remove(id);

        await firestoreAdapter.updateDocument('users/$userId', {
          'organizations': organizations,
        });
      }

      return getOrganization(id);
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
  Future<OrganizationModel> updateMember({
    String id,
    String userId,
    OrganizationRoleType role,
    OrganizationMemberStatus status,
  }) async {
    try {
      final map = <String, dynamic>{};

      if (role != null) {
        map['role'] = role.index;
      }

      if (status != null) {
        map['status'] = status.index;
      }

      await firestoreAdapter.updateDocument(
        'organizations/$id/members/$userId',
        map,
      );

      return getOrganization(id);
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
  Future<OrganizationModel> updateOrganization({
    String id,
    String name,
    String email,
    String phone,
    File avatar,
  }) async {
    try {
      final Map<String, dynamic> map = {};

      if (id != null) {
        map['id'] = id;
      }

      if (name != null) {
        map['name'] = name;
      }

      if (email != null) {
        map['email'] = email;
      }

      if (phone != null) {
        map['phone'] = phone;
      }

      if (avatar != null) {
        await firebaseStorageAdapter.uploadFile(
          file: avatar,
          storagePath: 'organizations/$id/avatar/avatar.png',
        );
        final avatarUrl = await firebaseStorageAdapter.getDownloadUrl(
          'organizations/$id/avatar/avatar.png',
        );
        map['avatarUrl'] = avatarUrl;
      }

      await firestoreAdapter.updateDocument(
        'organizations/$id',
        map,
      );

      return getOrganization(id);
    } on FirebaseException catch (error) {
      throw ServerException(
        localizedString.getLocalizedString('database-exceptions.get-error'),
        error.code,
        ExceptionOriginTypes.firebaseFirestore,
        stackTrace: error.stackTrace,
      );
    }
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
            ...(userDoc.data() as Map<String, dynamic>),
            ...(member.data() as Map<String, dynamic>),
          }));
        }
      }
    }

    return members;
  }
}
