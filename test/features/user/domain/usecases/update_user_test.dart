import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forest_map_app/core/enums/exception_origin_types.dart';
import 'package:forest_map_app/core/errors/failure.dart';
import 'package:forest_map_app/features/user/domain/entities/user.dart';
import 'package:forest_map_app/features/user/domain/repository/user_repository.dart';
import 'package:forest_map_app/features/user/domain/usecases/update_user.dart';
import 'package:mockito/mockito.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  MockUserRepository mockUserRepository;
  UpdateUser updateUser;

  setUp(() {
    mockUserRepository = MockUserRepository();
    updateUser = UpdateUser(mockUserRepository);
  });

  final tId = faker.guid.guid();
  final tName = faker.person.name();
  final tUser = User(id: tId, name: tName);

  final tErrorMessage = faker.randomGenerator.string(20);
  final tErrorCode = faker.randomGenerator.string(4);
  final tFailure = ServerFailure(
    tErrorMessage,
    tErrorCode,
    ExceptionOriginTypes.test,
  );

  test(
    'should return [User] if repository succeed',
    () async {
      when(mockUserRepository.updateUser(
        id: anyNamed('id'),
        name: anyNamed('name'),
        email: anyNamed('email'),
        organizations: anyNamed('organizations'),
        avatar: anyNamed('avatar'),
      )).thenAnswer(
        (_) async => Right(tUser),
      );

      final result = await updateUser(UpdateUserParams(id: tId, name: tName));

      expect(result, Right(tUser));
      verify(mockUserRepository.updateUser(id: tId, name: tName));
      verifyNoMoreInteractions(mockUserRepository);
    },
  );

  test(
    'should return [ServerFailure] when repository fails',
    () async {
      when(mockUserRepository.updateUser(
        id: anyNamed('id'),
        name: anyNamed('name'),
        email: anyNamed('email'),
        organizations: anyNamed('organizations'),
        avatar: anyNamed('avatar'),
      )).thenAnswer(
        (_) async => Left(tFailure),
      );

      final result = await updateUser(UpdateUserParams(id: tId, name: tName));

      expect(result, Left(tFailure));
      verify(mockUserRepository.updateUser(id: tId, name: tName));
      verifyNoMoreInteractions(mockUserRepository);
    },
  );
}
