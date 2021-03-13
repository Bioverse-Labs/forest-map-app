import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forest_map_app/core/enums/exception_origin_types.dart';
import 'package:forest_map_app/core/errors/exceptions.dart';
import 'package:forest_map_app/core/errors/failure.dart';
import 'package:forest_map_app/core/platform/network_info.dart';
import 'package:forest_map_app/features/user/data/datasource/user_local_data_source.dart';
import 'package:forest_map_app/features/user/data/datasource/user_remote_data_source.dart';
import 'package:forest_map_app/features/user/data/models/user_model.dart';
import 'package:forest_map_app/features/user/data/repository/user_repository_impl.dart';
import 'package:mockito/mockito.dart';

class MockUserRemoteDataSource extends Mock implements UserRemoteDataSource {}

class MockUserLocalDataSource extends Mock implements UserLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  MockUserRemoteDataSource mockRemoteDataSource;
  MockUserLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;
  UserRepositoryImpl userRepositoryImpl;

  setUp(() {
    mockRemoteDataSource = MockUserRemoteDataSource();
    mockLocalDataSource = MockUserLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    userRepositoryImpl = UserRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final tId = faker.guid.guid();
  final tName = faker.person.name();
  final tUserId = UserModel(id: tId, name: tName);

  final tErrorMessage = faker.randomGenerator.string(20);
  final tErrorCode = faker.randomGenerator.string(20);
  final tServerFailure = ServerFailure(
    tErrorMessage,
    tErrorCode,
    ExceptionOriginTypes.test,
  );

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

  group('getUser', () {
    runTestOnline(() {
      test(
        'should return [User] if data source succeed',
        () async {
          when(mockRemoteDataSource.getUser(any))
              .thenAnswer((_) async => tUserId);

          final result = await userRepositoryImpl.getUser(
            id: tId,
            searchLocally: false,
          );

          expect(result, Right(tUserId));
          verify(mockRemoteDataSource.getUser(tId));
          verifyNoMoreInteractions(mockRemoteDataSource);
        },
      );

      test(
        'should return [Failure] if data source fails',
        () async {
          when(mockRemoteDataSource.getUser(any)).thenThrow(ServerException(
            tServerFailure.message,
            tServerFailure.code,
            tServerFailure.origin,
          ));

          final result = await userRepositoryImpl.getUser(
            id: tId,
            searchLocally: false,
          );

          expect(result, Left(tServerFailure));
          verify(mockRemoteDataSource.getUser(tId));
          verifyNoMoreInteractions(mockRemoteDataSource);
        },
      );
    });

    runTestOffline(() {
      test(
        'should return [UserMode] if data source succeed',
        () async {
          when(mockLocalDataSource.getUser(any))
              .thenAnswer((_) async => tUserId);

          final result = await userRepositoryImpl.getUser(
            id: tId,
            searchLocally: false,
          );

          expect(result, Right(tUserId));
          verify(mockLocalDataSource.getUser(tId));
          verifyNoMoreInteractions(mockLocalDataSource);
        },
      );

      test(
        'should return [Failure] if data source fails',
        () async {
          when(mockLocalDataSource.getUser(any)).thenThrow(LocalException(
            tServerFailure.message,
            tServerFailure.code,
            tServerFailure.origin,
          ));

          final result = await userRepositoryImpl.getUser(
            id: tId,
            searchLocally: false,
          );

          expect(
            result,
            Left(LocalFailure(
              tServerFailure.message,
              tServerFailure.code,
              tServerFailure.origin,
            )),
          );
          verify(mockLocalDataSource.getUser(tId));
          verifyNoMoreInteractions(mockLocalDataSource);
        },
      );
    });
  });

  group('updateUser', () {
    runTestOnline(() {
      test(
        'should return [User] if data source succeed',
        () async {
          when(mockRemoteDataSource.updateUser(
            id: anyNamed('id'),
            name: anyNamed('name'),
            email: anyNamed('email'),
            organizations: anyNamed('organizations'),
            avatar: anyNamed('avatar'),
          )).thenAnswer((_) async => tUserId);

          final result = await userRepositoryImpl.updateUser(
            id: tId,
            name: tName,
          );

          expect(result, Right(tUserId));
          verify(mockRemoteDataSource.updateUser(id: tId, name: tName));
          verifyNoMoreInteractions(mockRemoteDataSource);
        },
      );

      test(
        'should return [Failure] if data source fails',
        () async {
          when(mockRemoteDataSource.updateUser(
            id: anyNamed('id'),
            name: anyNamed('name'),
            email: anyNamed('email'),
            organizations: anyNamed('organizations'),
            avatar: anyNamed('avatar'),
          )).thenThrow(ServerException(
            tServerFailure.message,
            tServerFailure.code,
            tServerFailure.origin,
          ));

          final result = await userRepositoryImpl.updateUser(
            id: tId,
            name: tName,
          );

          expect(result, Left(tServerFailure));
          verify(mockRemoteDataSource.updateUser(
            id: tId,
            name: tName,
          ));
          verifyNoMoreInteractions(mockRemoteDataSource);
        },
      );
    });

    runTestOffline(() {
      test(
        'should return [Failure] if user has no internet connection',
        () async {
          final result = await userRepositoryImpl.updateUser(
            id: tId,
            name: tName,
          );

          expect(result, Left(NoInternetFailure()));
          verifyZeroInteractions(mockRemoteDataSource);
        },
      );
    });
  });
}
