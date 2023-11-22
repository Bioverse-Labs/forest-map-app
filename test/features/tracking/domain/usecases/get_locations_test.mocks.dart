// Mocks generated by Mockito 5.4.3 from annotations
// in forest_map/test/features/tracking/domain/usecases/get_locations_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:dartz/dartz.dart' as _i2;
import 'package:forest_map/core/errors/failure.dart' as _i5;
import 'package:forest_map/features/tracking/data/models/location_model.dart'
    as _i7;
import 'package:forest_map/features/tracking/domain/entities/location.dart'
    as _i6;
import 'package:forest_map/features/tracking/domain/repositories/location_repository.dart'
    as _i3;
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

/// A class which mocks [LocationRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockLocationRepository extends _i1.Mock
    implements _i3.LocationRepository {
  MockLocationRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i4.Stream<_i6.Location>>>
      trackUserLocation() => (super.noSuchMethod(
            Invocation.method(
              #trackUserLocation,
              [],
            ),
            returnValue: _i4.Future<
                    _i2.Either<_i5.Failure, _i4.Stream<_i6.Location>>>.value(
                _FakeEither_0<_i5.Failure, _i4.Stream<_i6.Location>>(
              this,
              Invocation.method(
                #trackUserLocation,
                [],
              ),
            )),
          ) as _i4.Future<_i2.Either<_i5.Failure, _i4.Stream<_i6.Location>>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, void>> saveLocation(
    String? userId,
    _i7.LocationModel? location,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #saveLocation,
          [
            userId,
            location,
          ],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, void>>.value(
            _FakeEither_0<_i5.Failure, void>(
          this,
          Invocation.method(
            #saveLocation,
            [
              userId,
              location,
            ],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, void>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.Location>> getCurrentLocation() =>
      (super.noSuchMethod(
        Invocation.method(
          #getCurrentLocation,
          [],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i6.Location>>.value(
            _FakeEither_0<_i5.Failure, _i6.Location>(
          this,
          Invocation.method(
            #getCurrentLocation,
            [],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i6.Location>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i6.Location>>> getLocations(
          String? userId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getLocations,
          [userId],
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.Failure, List<_i6.Location>>>.value(
                _FakeEither_0<_i5.Failure, List<_i6.Location>>(
          this,
          Invocation.method(
            #getLocations,
            [userId],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, List<_i6.Location>>>);
}
