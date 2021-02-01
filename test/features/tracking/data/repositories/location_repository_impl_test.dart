import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forestMapApp/core/enums/exception_origin_types.dart';
import 'package:forestMapApp/core/errors/exceptions.dart';
import 'package:forestMapApp/core/errors/failure.dart';
import 'package:forestMapApp/core/platform/network_info.dart';
import 'package:forestMapApp/features/tracking/data/datasources/location_local_data_source.dart';
import 'package:forestMapApp/features/tracking/data/datasources/location_remote_data_source.dart';
import 'package:forestMapApp/features/tracking/data/models/location_model.dart';
import 'package:forestMapApp/features/tracking/data/repositories/location_repository_impl.dart';
import 'package:forestMapApp/features/tracking/domain/entities/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/mockito.dart';

class MockLocationRemoteDataSource extends Mock
    implements LocationRemoteDataSourceImpl {}

class MockLocationLocalDataSource extends Mock
    implements LocationLocalDataSourceImpl {}

class LocationLocalDatasource {}

class MockNetworkInfo extends Mock implements NetworkInfoImpl {}

void main() {
  MockLocationRemoteDataSource mockLocationRemoteDataSource;
  MockLocationLocalDataSource mockLocationLocalDataSource;
  MockNetworkInfo mockNetworkInfo;
  LocationRepositoryImpl locationRepositoryImpl;

  void runTestOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  setUp(() {
    mockLocationRemoteDataSource = MockLocationRemoteDataSource();
    mockLocationLocalDataSource = MockLocationLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    locationRepositoryImpl = LocationRepositoryImpl(
      localDataSource: mockLocationLocalDataSource,
      remoteDataSource: mockLocationRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final tId = faker.guid.guid();
  final tLat = faker.randomGenerator.decimal();
  final tLng = faker.randomGenerator.decimal();
  final tTimestamp = faker.date.dateTime();

  final tLocationModel = LocationModel(
    id: tId,
    lat: tLat,
    lng: tLng,
    timestamp: tTimestamp,
  );

  final tPosition = Position(
    latitude: tLat,
    longitude: tLng,
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

  Stream<Position> tPositionStream() async* {
    yield tPosition;
  }

  Stream<Location> tLocationStream() async* {
    yield tLocationModel;
  }

  runTestOnline(() {
    test('should return [LocationModel] if datasource succeed', () async {
      when(mockLocationRemoteDataSource.saveLocation(any))
          .thenAnswer((_) async => tLocationModel);

      final result = await locationRepositoryImpl.saveLocation(tLocationModel);

      expect(result, Right(tLocationModel));
      verify(
        mockLocationRemoteDataSource.saveLocation(tLocationModel.toMap()),
      );
      verifyNoMoreInteractions(mockLocationRemoteDataSource);
    });

    test('should return [ServerFailure] if datasource fails', () async {
      when(mockLocationRemoteDataSource.saveLocation(any))
          .thenThrow(tServerException);

      final result = await locationRepositoryImpl.saveLocation(tLocationModel);

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
        mockLocationRemoteDataSource.saveLocation(tLocationModel.toMap()),
      );
      verifyNoMoreInteractions(mockLocationRemoteDataSource);
    });
  });

  runTestOffline(() {
    test('should return [LocationModel] if datasource succeed', () async {
      when(mockLocationLocalDataSource.saveLocation(any))
          .thenAnswer((_) async => tLocationModel);

      final result = await locationRepositoryImpl.saveLocation(tLocationModel);

      expect(result, Right(tLocationModel));
      verify(
        mockLocationLocalDataSource.saveLocation(tLocationModel.toMap()),
      );
      verifyNoMoreInteractions(mockLocationLocalDataSource);
    });

    test('should return [LocalFailure] if datasource fails', () async {
      when(mockLocationLocalDataSource.saveLocation(any))
          .thenThrow(tLocalException);

      final result = await locationRepositoryImpl.saveLocation(tLocationModel);

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
        mockLocationLocalDataSource.saveLocation(tLocationModel.toMap()),
      );
      verifyNoMoreInteractions(mockLocationLocalDataSource);
    });
  });

  group('trackUserLocation', () {
    test(
      'should return [Stream] if datasource succeed',
      () async {
        when(mockLocationLocalDataSource.getPositionStream())
            .thenAnswer((_) async => tPositionStream());

        final result = await locationRepositoryImpl.trackUserLocation();

        result.fold(
          (l) => null,
          (stream) => stream.listen(expectAsync1(
            (location) {
              expect(location, tLocationModel);
            },
          )),
        );
        verify(mockLocationLocalDataSource.getPositionStream());
        verifyNoMoreInteractions(mockLocationLocalDataSource);
      },
    );

    test(
      'should throw [LocationException] if datasource fails',
      () async {
        when(mockLocationLocalDataSource.getPositionStream()).thenThrow(
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
        verify(mockLocationLocalDataSource.getPositionStream());
        verifyNoMoreInteractions(mockLocationLocalDataSource);
      },
    );
  });
}
