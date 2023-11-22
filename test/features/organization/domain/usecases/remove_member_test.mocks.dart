// Mocks generated by Mockito 5.4.3 from annotations
// in forest_map/test/features/organization/domain/usecases/remove_member_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;
import 'dart:io' as _i8;

import 'package:dartz/dartz.dart' as _i2;
import 'package:forest_map/core/enums/organization_member_status.dart' as _i10;
import 'package:forest_map/core/enums/organization_role_types.dart' as _i9;
import 'package:forest_map/core/errors/failure.dart' as _i5;
import 'package:forest_map/features/organization/domain/entities/organization.dart'
    as _i6;
import 'package:forest_map/features/organization/domain/repositories/organization_repository.dart'
    as _i3;
import 'package:forest_map/features/user/domain/entities/user.dart' as _i7;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeEither_0<L, R> extends _i1.SmartFake implements _i2.Either<L, R> {
  _FakeEither_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [OrganizationRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockOrganizationRepository extends _i1.Mock
    implements _i3.OrganizationRepository {
  MockOrganizationRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.Organization>> createOrganization({
    required _i7.User? user,
    required String? name,
    required String? email,
    required String? phone,
    _i8.File? avatar,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #createOrganization,
          [],
          {
            #user: user,
            #name: name,
            #email: email,
            #phone: phone,
            #avatar: avatar,
          },
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.Failure, _i6.Organization>>.value(
                _FakeEither_0<_i5.Failure, _i6.Organization>(
          this,
          Invocation.method(
            #createOrganization,
            [],
            {
              #user: user,
              #name: name,
              #email: email,
              #phone: phone,
              #avatar: avatar,
            },
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i6.Organization>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.Organization?>> getOrganization({
    required String? id,
    required bool? searchLocally,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getOrganization,
          [],
          {
            #id: id,
            #searchLocally: searchLocally,
          },
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.Failure, _i6.Organization?>>.value(
                _FakeEither_0<_i5.Failure, _i6.Organization?>(
          this,
          Invocation.method(
            #getOrganization,
            [],
            {
              #id: id,
              #searchLocally: searchLocally,
            },
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i6.Organization?>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.Organization>> updateOrganization({
    required String? id,
    String? name,
    String? email,
    String? phone,
    _i8.File? avatar,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateOrganization,
          [],
          {
            #id: id,
            #name: name,
            #email: email,
            #phone: phone,
            #avatar: avatar,
          },
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.Failure, _i6.Organization>>.value(
                _FakeEither_0<_i5.Failure, _i6.Organization>(
          this,
          Invocation.method(
            #updateOrganization,
            [],
            {
              #id: id,
              #name: name,
              #email: email,
              #phone: phone,
              #avatar: avatar,
            },
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i6.Organization>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, void>> deleteOrganization(String? id) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteOrganization,
          [id],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, void>>.value(
            _FakeEither_0<_i5.Failure, void>(
          this,
          Invocation.method(
            #deleteOrganization,
            [id],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, void>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.Organization>> addMember({
    required String? id,
    required _i7.User? user,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #addMember,
          [],
          {
            #id: id,
            #user: user,
          },
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.Failure, _i6.Organization>>.value(
                _FakeEither_0<_i5.Failure, _i6.Organization>(
          this,
          Invocation.method(
            #addMember,
            [],
            {
              #id: id,
              #user: user,
            },
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i6.Organization>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.Organization>> updateMember({
    required String? id,
    required String? userId,
    _i9.OrganizationRoleType? role,
    _i10.OrganizationMemberStatus? status,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateMember,
          [],
          {
            #id: id,
            #userId: userId,
            #role: role,
            #status: status,
          },
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.Failure, _i6.Organization>>.value(
                _FakeEither_0<_i5.Failure, _i6.Organization>(
          this,
          Invocation.method(
            #updateMember,
            [],
            {
              #id: id,
              #userId: userId,
              #role: role,
              #status: status,
            },
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i6.Organization>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.Organization>> removeMember({
    required String? id,
    required String? userId,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #removeMember,
          [],
          {
            #id: id,
            #userId: userId,
          },
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.Failure, _i6.Organization>>.value(
                _FakeEither_0<_i5.Failure, _i6.Organization>(
          this,
          Invocation.method(
            #removeMember,
            [],
            {
              #id: id,
              #userId: userId,
            },
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i6.Organization>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, void>> saveOrganizationLocally({
    required String? id,
    required _i6.Organization? organization,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #saveOrganizationLocally,
          [],
          {
            #id: id,
            #organization: organization,
          },
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, void>>.value(
            _FakeEither_0<_i5.Failure, void>(
          this,
          Invocation.method(
            #saveOrganizationLocally,
            [],
            {
              #id: id,
              #organization: organization,
            },
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, void>>);
}
