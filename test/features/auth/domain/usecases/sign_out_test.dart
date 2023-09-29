import 'package:dartz/dartz.dart';
import 'package:forest_map/core/usecases/usecase.dart';
import 'package:forest_map/features/auth/domain/usecases/sign_out.dart';
import 'package:forest_map/features/auth/domain/repositories/auth_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'sign_out_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late SignOut usecase;
  late MockAuthRepository mockAuthRepository;

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
