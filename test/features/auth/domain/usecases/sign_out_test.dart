import 'package:dartz/dartz.dart';
import 'package:forest_map_app/core/usecases/usecase.dart';
import 'package:forest_map_app/features/auth/domain/usecases/sign_out.dart';
import 'package:forest_map_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  SignOut usecase;
  MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = SignOut(mockAuthRepository);
  });

  test('should signOut', () async {
    when(mockAuthRepository.signOut()).thenAnswer((_) async => Right(null));

    final result = await usecase(NoParams());

    expect(result, Right(null));
    verify(mockAuthRepository.signOut());
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
