import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forest_map_app/core/enums/exception_origin_types.dart';
import 'package:forest_map_app/core/errors/failure.dart';
import 'package:forest_map_app/features/user/domain/entities/user.dart';
import 'package:forest_map_app/features/user/domain/repository/user_repository.dart';
import 'package:forest_map_app/features/user/domain/usecases/get_user.dart';
import 'package:mockito/mockito.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  MockUserRepository mockUserRepository;
  GetUser getUser;

  setUp(() {
    mockUserRepository = MockUserRepository();
    getUser = GetUser(mockUserRepository);
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
      when(mockUserRepository.getUser(
        id: anyNamed('id'),
        searchLocally: anyNamed('searchLocally'),
      )).thenAnswer(
        (_) async => Right(tUser),
      );

      final result = await getUser(GetUserParams(
        id: tId,
        searchLocally: false,
      ));

      expect(result, Right(tUser));
      verify(mockUserRepository.getUser(
        id: tId,
        searchLocally: false,
      ));
      verifyNoMoreInteractions(mockUserRepository);
    },
  );

  test(
    'should return [ServerFailure] when repository fails',
    () async {
      when(mockUserRepository.getUser(
        id: anyNamed('id'),
        searchLocally: anyNamed('searchLocally'),
      )).thenAnswer(
        (_) async => Left(tFailure),
      );

      final result = await getUser(GetUserParams(
        id: tId,
        searchLocally: false,
      ));

      expect(result, Left(tFailure));
      verify(mockUserRepository.getUser(
        id: tId,
        searchLocally: false,
      ));
      verifyNoMoreInteractions(mockUserRepository);
    },
  );
}
