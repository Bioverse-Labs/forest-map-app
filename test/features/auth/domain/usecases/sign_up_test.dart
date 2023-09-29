import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:forest_map/features/user/domain/entities/user.dart';
import 'package:forest_map/features/auth/domain/repositories/auth_repository.dart';
import 'package:forest_map/features/auth/domain/usecases/sign_up.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  SignUp usecase;
  MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = SignUp(mockAuthRepository);
  });

  final name = faker.person.name();
  final email = faker.internet.email();
  final password = faker.internet.password();

  final tUser = User(id: faker.guid.guid(), name: name, email: email);

  test('should return User from signUp', () async {
    when(mockAuthRepository.signUp(any, any, any))
        .thenAnswer((_) async => Right(tUser));

    final result = await usecase(SignUpParams(name, email, password));

    expect(result, Right(tUser));
    verify(mockAuthRepository.signUp(name, email, password));
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
