import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:forestMapApp/core/entities/user.dart';
import 'package:forestMapApp/features/login/domain/repositories/login_repository.dart';
import 'package:forestMapApp/features/login/domain/usecases/login_with_email_and_password.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockLoginRepository extends Mock implements LoginRepository {}

void main() {
  LoginWithEmailAndPassword usecase;
  MockLoginRepository mockLoginRepository;

  setUp(() {
    mockLoginRepository = MockLoginRepository();
    usecase = LoginWithEmailAndPassword(mockLoginRepository);
  });

  final email = faker.internet.email();
  final password = faker.internet.password();
  final user = User(id: faker.guid.guid(), name: faker.person.name());

  test('should return user after success login', () async {
    when(mockLoginRepository.loginWithEmailAndPassword(any, any))
        .thenAnswer((_) async => Right(user));

    final result = await usecase(LoginParams(email, password));

    expect(result, Right(user));
    verify(mockLoginRepository.loginWithEmailAndPassword(email, password));
    verifyNoMoreInteractions(mockLoginRepository);
  });
}
