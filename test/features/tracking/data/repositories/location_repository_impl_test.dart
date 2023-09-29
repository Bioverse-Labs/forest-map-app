import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forest_map/core/enums/exception_origin_types.dart';
import 'package:forest_map/core/errors/exceptions.dart';
import 'package:forest_map/core/errors/failure.dart';
import 'package:forest_map/core/platform/network_info.dart';
import 'package:forest_map/features/tracking/data/datasources/location_local_data_source.dart';
import 'package:forest_map/features/tracking/data/datasources/location_remote_data_source.dart';
import 'package:forest_map/features/tracking/data/models/location_model.dart';
import 'package:forest_map/features/tracking/data/repositories/location_repository_impl.dart';
import 'package:forest_map/features/tracking/domain/entities/location.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'location_repository_impl_test.mocks.dart';

@GenerateMocks([
  LocationRemoteDataSource,
  LocationLocalDataSource,
  NetworkInfoImpl,
])
void main() {
  late MockLocationRemoteDataSource mockLocationRemoteDataSource;
  late MockLocationLocalDataSource mockLocationDataSource;
  late MockNetworkInfoImpl mockNetworkInfoImpl;
  late LocationRepositoryImpl locationRepositoryImpl;

  setUp(() {
    mockLocationRemoteDataSource = MockLocationRemoteDataSource();
    mockLocationDataSource = MockLocationLocalDataSource();
    mockNetworkInfoImpl = MockNetworkInfoImpl();
    locationRepositoryImpl = LocationRepositoryImpl(
      localDataSource: mockLocationDataSource,
      networkInfo: mockNetworkInfoImpl,
      remoteDataSource: mockLocationRemoteDataSource,
    );

    when(mockNetworkInfoImpl.isConnected).thenAnswer((_) async => false);
  });

  final tId = faker.guid.guid();
  final tLat = faker.randomGenerator.decimal();
  final tLng = faker.randomGenerator.decimal();
  final tTimestamp = DateTime.now();

  final tLocationModel = LocationModel(
    id: tId,
    lat: tLat,
    lng: tLng,
    timestamp: tTimestamp,
  );

  final tServerException = ServerException(
    faker.randomGenerator.string(20),
    faker.randomGenerator.string(4),
    ExceptionOriginTypes.test,
    stackTrace: StackTrace.empty,
  );

  final tLocalException = LocalException(
    faker.randomGenerator.string(20),
    faker.randomGenerator.string(4),
    ExceptionOriginTypes.test,
    stackTrace: StackTrace.empty,
  );

  final tLocationException = LocationException(
    faker.randomGenerator.string(20),
    false,
    false,
  );

  Stream<Location> tLocationStream() async* {
    yield tLocationModel;
  }

  group('saveLocation', () {
    final tUserId = faker.guid.guid();

    test('should return [LocationModel] if datasource succeed', () async {
      when(mockLocationDataSource.saveLocation(any, any))
          .thenAnswer((_) async => tLocationModel);

      await locationRepositoryImpl.saveLocation(tUserId, tLocationModel);

      verify(
        mockLocationDataSource.saveLocation(tUserId, tLocationModel),
      );
      verifyNoMoreInteractions(mockLocationDataSource);
    });

    test('should return [ServerFailure] if datasource fails', () async {
      when(mockLocationDataSource.saveLocation(any, any))
          .thenThrow(tServerException);

      final result =
          await locationRepositoryImpl.saveLocation(tUserId, tLocationModel);

      expect(
        result,
        Left(ServerFailure(
          tServerException.message,
          tServerException.code,
          tServerException.origin,
          stackTrace: tServerException.stackTrace,
        )),
      );
      verify(
        mockLocationDataSource.saveLocation(tUserId, tLocationModel),
      );
      verifyNoMoreInteractions(mockLocationDataSource);
    });

    test('should return [LocalFailure] if datasource fails', () async {
      when(mockLocationDataSource.saveLocation(any, any))
          .thenThrow(tLocalException);

      final result =
          await locationRepositoryImpl.saveLocation(tUserId, tLocationModel);

      expect(
        result,
        Left(LocalFailure(
          tLocalException.message,
          tLocalException.code,
          tLocalException.origin,
          stackTrace: tLocalException.stackTrace,
        )),
      );
      verify(
        mockLocationDataSource.saveLocation(tUserId, tLocationModel),
      );
      verifyNoMoreInteractions(mockLocationDataSource);
    });
  });

  group('trackUserLocation', () {
    test(
      'should return [Stream] if datasource succeed',
      () async {
        when(mockLocationDataSource.getPositionStream())
            .thenAnswer((_) async => tLocationStream());

        final result = await locationRepositoryImpl.trackUserLocation();

        result.fold(
          (l) => null,
          (stream) => stream.listen(expectAsync1(
            (location) {
              expect(location, tLocationModel);
            },
          )),
        );
        verify(mockLocationDataSource.getPositionStream());
        verifyNoMoreInteractions(mockLocationDataSource);
      },
    );

    test(
      'should throw [LocationException] if datasource fails',
      () async {
        when(mockLocationDataSource.getPositionStream()).thenThrow(
          tLocationException,
        );

        final result = await locationRepositoryImpl.trackUserLocation();

        expect(
          result,
          Left(LocationFailure(
            tLocationException.message,
            tLocationException.hasPermission,
            tLocationException.isGpsEnabled,
            stackTrace: tLocationException.stackTrace,
          )),
        );
        verify(mockLocationDataSource.getPositionStream());
        verifyNoMoreInteractions(mockLocationDataSource);
      },
    );

    test(
      'should throw [LocationException] if datasource fails',
      () async {
        when(mockLocationDataSource.getPositionStream()).thenThrow(
          tLocalException,
        );

        final result = await locationRepositoryImpl.trackUserLocation();

        expect(
          result,
          Left(LocalFailure(
            tLocalException.message,
            tLocalException.code,
            tLocalException.origin,
            stackTrace: tLocalException.stackTrace,
          )),
        );
        verify(mockLocationDataSource.getPositionStream());
        verifyNoMoreInteractions(mockLocationDataSource);
      },
    );
  });

  group('getCurrentLocation', () {
    test(
      'should return [LocationModel] if datasource succeed',
      () async {
        when(mockLocationDataSource.getCurrentLocation())
            .thenAnswer((_) async => tLocationModel);

        final result = await locationRepositoryImpl.getCurrentLocation();

        expect(result, Right(tLocationModel));
        verify(mockLocationDataSource.getCurrentLocation());
        verifyNoMoreInteractions(mockLocationDataSource);
      },
    );

    test(
      'should throw [LocationException] if datasource fails',
      () async {
        when(mockLocationDataSource.getCurrentLocation()).thenThrow(
          tLocationException,
        );

        final result = await locationRepositoryImpl.getCurrentLocation();

        expect(
          result,
          Left(LocationFailure(
            tLocationException.message,
            tLocationException.hasPermission,
            tLocationException.isGpsEnabled,
            stackTrace: tLocationException.stackTrace,
          )),
        );
        verify(mockLocationDataSource.getCurrentLocation());
        verifyNoMoreInteractions(mockLocationDataSource);
      },
    );

    test(
      'should throw [LocationException] if datasource fails',
      () async {
        when(mockLocationDataSource.getCurrentLocation()).thenThrow(
          tLocalException,
        );

        final result = await locationRepositoryImpl.getCurrentLocation();

        expect(
          result,
          Left(LocalFailure(
            tLocalException.message,
            tLocalException.code,
            tLocalException.origin,
            stackTrace: tLocalException.stackTrace,
          )),
        );
        verify(mockLocationDataSource.getCurrentLocation());
        verifyNoMoreInteractions(mockLocationDataSource);
      },
    );
  });
}
