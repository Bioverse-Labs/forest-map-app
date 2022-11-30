import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:forest_map_app/features/user/domain/entities/user.dart';
import 'package:forest_map_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:forest_map_app/features/auth/domain/usecases/sign_in_with_email_and_password.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  SignInWithEmailAndPassword usecase;
  MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = SignInWithEmailAndPassword(mockAuthRepository);
  });

  final email = faker.internet.email();
  final password = faker.internet.password();
  final tUser = User(id: faker.guid.guid(), name: faker.person.name());

  test('should return User from signIn', () async {
    when(mockAuthRepository.signInWithEmailAndPassword(any, any))
        .thenAnswer((_) async => Right(tUser));

    final result =
        await usecase(SignInWithEmailAndPasswordParams(email, password));

    expect(result, Right(tUser));
    verify(mockAuthRepository.signInWithEmailAndPassword(email, password));
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
