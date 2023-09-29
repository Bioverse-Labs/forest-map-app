import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:forest_map/features/user/domain/entities/user.dart';
import 'package:forest_map/core/enums/social_login_types.dart';
import 'package:forest_map/features/auth/domain/repositories/auth_repository.dart';
import 'package:forest_map/features/auth/domain/usecases/sign_in_with_social.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  SignInWithSocial usecase;
  MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = SignInWithSocial(mockAuthRepository);
  });

  final tUser = User(id: faker.guid.guid(), name: faker.person.name());

  test('should return User from social signIn', () async {
    when(mockAuthRepository.signInWithSocial(any))
        .thenAnswer((_) async => Right(tUser));

    final result =
        await usecase(SignInWithSocialParams(SocialLoginType.facebook));

    expect(result, Right(tUser));
    verify(mockAuthRepository.signInWithSocial(SocialLoginType.facebook));
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
