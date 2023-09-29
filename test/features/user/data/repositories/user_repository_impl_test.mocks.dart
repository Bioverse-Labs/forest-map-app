// Mocks generated by Mockito 5.4.0 from annotations
// in forest_map/test/features/user/data/repositories/user_repository_impl_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;
import 'dart:io' as _i6;

import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart'
    as _i10;
import 'package:forest_map/core/platform/network_info.dart' as _i9;
import 'package:forest_map/features/organization/domain/entities/organization.dart'
    as _i5;
import 'package:forest_map/features/user/data/datasource/user_local_data_source.dart'
    as _i7;
import 'package:forest_map/features/user/data/datasource/user_remote_data_source.dart'
    as _i3;
import 'package:forest_map/features/user/data/models/user_model.dart' as _i2;
import 'package:forest_map/features/user/domain/entities/user.dart' as _i8;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeUserModel_0 extends _i1.SmartFake implements _i2.UserModel {
  _FakeUserModel_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [UserRemoteDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserRemoteDataSource extends _i1.Mock
    implements _i3.UserRemoteDataSource {
  MockUserRemoteDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.UserModel> getUser(String? id) => (super.noSuchMethod(
        Invocation.method(
          #getUser,
          [id],
        ),
        returnValue: _i4.Future<_i2.UserModel>.value(_FakeUserModel_0(
          this,
          Invocation.method(
            #getUser,
            [id],
          ),
        )),
      ) as _i4.Future<_i2.UserModel>);
  @override
  _i4.Future<_i2.UserModel> updateUser({
    required String? id,
    String? name,
    String? email,
    List<_i5.Organization>? organizations,
    _i6.File? avatar,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateUser,
          [],
          {
            #id: id,
            #name: name,
            #email: email,
            #organizations: organizations,
            #avatar: avatar,
          },
        ),
        returnValue: _i4.Future<_i2.UserModel>.value(_FakeUserModel_0(
          this,
          Invocation.method(
            #updateUser,
            [],
            {
              #id: id,
              #name: name,
              #email: email,
              #organizations: organizations,
              #avatar: avatar,
            },
          ),
        )),
      ) as _i4.Future<_i2.UserModel>);
}

/// A class which mocks [UserLocalDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserLocalDataSource extends _i1.Mock
    implements _i7.UserLocalDataSource {
  MockUserLocalDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.UserModel?> getUser(String? id) => (super.noSuchMethod(
        Invocation.method(
          #getUser,
          [id],
        ),
        returnValue: _i4.Future<_i2.UserModel?>.value(),
      ) as _i4.Future<_i2.UserModel?>);
  @override
  _i4.Future<void> saveUser({
    String? id,
    _i8.User? user,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #saveUser,
          [],
          {
            #id: id,
            #user: user,
          },
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
}

/// A class which mocks [NetworkInfo].
///
/// See the documentation for Mockito's code generation for more information.
class MockNetworkInfo extends _i1.Mock implements _i9.NetworkInfo {
  MockNetworkInfo() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<bool> get isConnected => (super.noSuchMethod(
        Invocation.getter(#isConnected),
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);
  @override
  _i4.Future<bool> get isWifi => (super.noSuchMethod(
        Invocation.getter(#isWifi),
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);
  @override
  _i4.Stream<_i10.DataConnectionStatus> get connectionStatusStream =>
      (super.noSuchMethod(
        Invocation.getter(#connectionStatusStream),
        returnValue: _i4.Stream<_i10.DataConnectionStatus>.empty(),
      ) as _i4.Stream<_i10.DataConnectionStatus>);
}
