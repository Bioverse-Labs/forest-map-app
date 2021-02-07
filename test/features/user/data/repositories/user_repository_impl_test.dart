import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forestMapApp/core/enums/exception_origin_types.dart';
import 'package:forestMapApp/core/errors/exceptions.dart';
import 'package:forestMapApp/core/errors/failure.dart';
import 'package:forestMapApp/features/user/data/datasource/user_data_source.dart';
import 'package:forestMapApp/features/user/data/models/user_model.dart';
import 'package:forestMapApp/features/user/data/repository/user_repository_impl.dart';
import 'package:mockito/mockito.dart';

class MockUserDataSource extends Mock implements UserDataSource {}

void main() {
  MockUserDataSource mockUserDataSource;
  UserRepositoryImpl userRepositoryImpl;

  setUp(() {
    mockUserDataSource = MockUserDataSource();
    userRepositoryImpl = UserRepositoryImpl(dataSource: mockUserDataSource);
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

  group('getUser', () {
    test(
      'should return [User] if data source succeed',
      () async {
        when(mockUserDataSource.getUser(any)).thenAnswer((_) async => tUserId);

        final result = await userRepositoryImpl.getUser(tId);

        expect(result, Right(tUserId));
        verify(mockUserDataSource.getUser(tId));
        verifyNoMoreInteractions(mockUserDataSource);
      },
    );

    test(
      'should return [Failure] if data source fails',
      () async {
        when(mockUserDataSource.getUser(any)).thenThrow(ServerException(
          tServerFailure.message,
          tServerFailure.code,
          tServerFailure.origin,
        ));

        final result = await userRepositoryImpl.getUser(tId);

        expect(result, Left(tServerFailure));
        verify(mockUserDataSource.getUser(tId));
        verifyNoMoreInteractions(mockUserDataSource);
      },
    );
  });

  group('updateUser', () {
    test(
      'should return [User] if data source succeed',
      () async {
        when(mockUserDataSource.updateUser(
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
        verify(mockUserDataSource.updateUser(id: tId, name: tName));
        verifyNoMoreInteractions(mockUserDataSource);
      },
    );

    test(
      'should return [Failure] if data source fails',
      () async {
        when(mockUserDataSource.updateUser(
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
        verify(mockUserDataSource.updateUser(
          id: tId,
          name: tName,
        ));
        verifyNoMoreInteractions(mockUserDataSource);
      },
    );
  });
}
