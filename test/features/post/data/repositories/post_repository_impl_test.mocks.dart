// Mocks generated by Mockito 5.4.0 from annotations
// in forest_map/test/features/post/data/repositories/post_repository_impl_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart'
    as _i8;
import 'package:forest_map/core/platform/location.dart' as _i9;
import 'package:forest_map/core/platform/network_info.dart' as _i7;
import 'package:forest_map/core/util/uuid_generator.dart' as _i10;
import 'package:forest_map/features/post/data/datasources/post_local_data_source.dart'
    as _i6;
import 'package:forest_map/features/post/data/datasources/post_remote_data_source.dart'
    as _i3;
import 'package:forest_map/features/post/data/models/post_model.dart' as _i5;
import 'package:forest_map/features/tracking/domain/entities/location.dart'
    as _i2;
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

class _FakeLocation_0 extends _i1.SmartFake implements _i2.Location {
  _FakeLocation_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [PostRemoteDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockPostRemoteDataSource extends _i1.Mock
    implements _i3.PostRemoteDataSource {
  MockPostRemoteDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<void> savePost(_i5.PostModel? post) => (super.noSuchMethod(
        Invocation.method(
          #savePost,
          [post],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  _i4.Future<List<_i5.PostModel>> getPosts({required String? orgId}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getPosts,
          [],
          {#orgId: orgId},
        ),
        returnValue: _i4.Future<List<_i5.PostModel>>.value(<_i5.PostModel>[]),
      ) as _i4.Future<List<_i5.PostModel>>);
}

/// A class which mocks [PostLocalDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockPostLocalDataSource extends _i1.Mock
    implements _i6.PostLocalDataSource {
  MockPostLocalDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<void> savePost(
    _i5.PostModel? post, {
    bool? isPendingPost,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #savePost,
          [post],
          {#isPendingPost: isPendingPost},
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  _i4.Future<void> deletePost(
    String? id, {
    bool? isPendingPost,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #deletePost,
          [id],
          {#isPendingPost: isPendingPost},
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  _i4.Future<void> syncPosts(List<_i5.PostModel>? posts) => (super.noSuchMethod(
        Invocation.method(
          #syncPosts,
          [posts],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  _i4.Future<List<_i5.PostModel>> getAllOrgPosts(
    String? orgId, {
    bool? isPendingPost,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAllOrgPosts,
          [orgId],
          {#isPendingPost: isPendingPost},
        ),
        returnValue: _i4.Future<List<_i5.PostModel>>.value(<_i5.PostModel>[]),
      ) as _i4.Future<List<_i5.PostModel>>);
  @override
  _i4.Future<List<_i5.PostModel>> getAllPosts({bool? isPendingPost}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAllPosts,
          [],
          {#isPendingPost: isPendingPost},
        ),
        returnValue: _i4.Future<List<_i5.PostModel>>.value(<_i5.PostModel>[]),
      ) as _i4.Future<List<_i5.PostModel>>);
}

/// A class which mocks [NetworkInfo].
///
/// See the documentation for Mockito's code generation for more information.
class MockNetworkInfo extends _i1.Mock implements _i7.NetworkInfo {
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
  _i4.Stream<_i8.DataConnectionStatus> get connectionStatusStream =>
      (super.noSuchMethod(
        Invocation.getter(#connectionStatusStream),
        returnValue: _i4.Stream<_i8.DataConnectionStatus>.empty(),
      ) as _i4.Stream<_i8.DataConnectionStatus>);
}

/// A class which mocks [LocationUtils].
///
/// See the documentation for Mockito's code generation for more information.
class MockLocationUtils extends _i1.Mock implements _i9.LocationUtils {
  MockLocationUtils() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<bool> get isServiceEnabled => (super.noSuchMethod(
        Invocation.getter(#isServiceEnabled),
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);
  @override
  _i4.Future<bool> checkLocationPermission() => (super.noSuchMethod(
        Invocation.method(
          #checkLocationPermission,
          [],
        ),
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);
  @override
  _i4.Future<_i2.Location> getCurrentPosition(bool? hasPermission) =>
      (super.noSuchMethod(
        Invocation.method(
          #getCurrentPosition,
          [hasPermission],
        ),
        returnValue: _i4.Future<_i2.Location>.value(_FakeLocation_0(
          this,
          Invocation.method(
            #getCurrentPosition,
            [hasPermission],
          ),
        )),
      ) as _i4.Future<_i2.Location>);
  @override
  _i4.Future<_i2.Location> getLastKnowPosition(bool? hasPermission) =>
      (super.noSuchMethod(
        Invocation.method(
          #getLastKnowPosition,
          [hasPermission],
        ),
        returnValue: _i4.Future<_i2.Location>.value(_FakeLocation_0(
          this,
          Invocation.method(
            #getLastKnowPosition,
            [hasPermission],
          ),
        )),
      ) as _i4.Future<_i2.Location>);
  @override
  _i4.Future<_i4.Stream<_i2.Location>> getLocationStream(bool? hasPermission) =>
      (super.noSuchMethod(
        Invocation.method(
          #getLocationStream,
          [hasPermission],
        ),
        returnValue: _i4.Future<_i4.Stream<_i2.Location>>.value(
            _i4.Stream<_i2.Location>.empty()),
      ) as _i4.Future<_i4.Stream<_i2.Location>>);
}

/// A class which mocks [UUIDGenerator].
///
/// See the documentation for Mockito's code generation for more information.
class MockUUIDGenerator extends _i1.Mock implements _i10.UUIDGenerator {
  MockUUIDGenerator() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String generateUID() => (super.noSuchMethod(
        Invocation.method(
          #generateUID,
          [],
        ),
        returnValue: '',
      ) as String);
}
