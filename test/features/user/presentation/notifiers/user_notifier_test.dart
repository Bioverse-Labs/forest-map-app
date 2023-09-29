import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forest_map/core/enums/exception_origin_types.dart';
import 'package:forest_map/core/errors/failure.dart';
import 'package:forest_map/features/user/domain/entities/user.dart';
import 'package:forest_map/features/user/domain/usecases/get_user.dart';
import 'package:forest_map/features/user/domain/usecases/update_user.dart';
import 'package:forest_map/features/user/presentation/notifiers/user_notifier.dart';
import 'package:mockito/mockito.dart';

import '../../../../core/notifiers/change_notifiers.dart';

class MockGetUserUseCase extends Mock implements GetUser {}

class MockUpdateUserUseCase extends Mock implements UpdateUser {}

void main() {
  MockGetUserUseCase mockGetUserUseCase;
  MockUpdateUserUseCase mockUpdateUserUseCase;
  UserNotifierImpl userNotifierImpl;

  setUp(() {
    mockGetUserUseCase = MockGetUserUseCase();
    mockUpdateUserUseCase = MockUpdateUserUseCase();
    userNotifierImpl = UserNotifierImpl(
      getUserUseCase: mockGetUserUseCase,
      updateUserUseCase: mockUpdateUserUseCase,
    );
  });

  final tId = faker.guid.guid();
  final tName = faker.person.name();
  final tEmail = faker.internet.email();
  final tUser = User(id: tId, name: tName);
  final tFailure = ServerFailure(
    faker.randomGenerator.string(20),
    faker.randomGenerator.string(20),
    ExceptionOriginTypes.test,
  );

  group('geUser', () {
    test(
      'should set [User] and notifiy all listeners if usecase succeed',
      () async {
        when(mockGetUserUseCase(any)).thenAnswer((_) async => Right(tUser));

        await expectToNotifiyListener<UserNotifierImpl>(
          userNotifierImpl,
          () => userNotifierImpl.getUser(id: tId),
          [
            NotifierAssertParams(
              value: (notifier) => notifier.isLoading,
              matcher: true,
            ),
            NotifierAssertParams(
              value: (notifier) => notifier.isLoading,
              matcher: false,
            ),
            NotifierAssertParams(
              value: (notifier) => notifier.user,
              matcher: tUser,
            ),
          ],
        );

        verify(mockGetUserUseCase(GetUserParams(
          id: tId,
          searchLocally: false,
        )));
        verifyNoMoreInteractions(mockGetUserUseCase);
      },
    );

    test(
      'should throw [Failure] if useCase fails',
      () async {
        when(mockGetUserUseCase(any)).thenAnswer((_) async => Left(tFailure));

        final call = userNotifierImpl.getUser;

        expect(
          () => call(id: tId),
          throwsA(isInstanceOf<ServerFailure>()),
        );

        verify(mockGetUserUseCase(GetUserParams(
          id: tId,
          searchLocally: false,
        )));
        verifyNoMoreInteractions(mockGetUserUseCase);
      },
    );
  });

  group('updateUser', () {
    test(
      'should set [User] and notifiy all listeners if usecase succeed',
      () async {
        when(mockUpdateUserUseCase(any)).thenAnswer((_) async => Right(tUser));

        await expectToNotifiyListener<UserNotifierImpl>(
          userNotifierImpl,
          () => userNotifierImpl.updateUser(id: tId, email: tEmail),
          [
            NotifierAssertParams(
              value: (notifier) => notifier.isLoading,
              matcher: true,
            ),
            NotifierAssertParams(
              value: (notifier) => notifier.isLoading,
              matcher: false,
            ),
            NotifierAssertParams(
              value: (notifier) => notifier.user,
              matcher: tUser,
            ),
          ],
        );

        verify(mockUpdateUserUseCase(UpdateUserParams(id: tId, email: tEmail)));
        verifyNoMoreInteractions(mockGetUserUseCase);
      },
    );

    test(
      'should throw [Failure] if useCase fails',
      () async {
        when(mockUpdateUserUseCase(any)).thenAnswer(
          (_) async => Left(tFailure),
        );

        final call = userNotifierImpl.updateUser;

        expect(
          () => call(id: tId, email: tEmail),
          throwsA(isInstanceOf<ServerFailure>()),
        );

        verify(mockUpdateUserUseCase(UpdateUserParams(id: tId, email: tEmail)));
        verifyNoMoreInteractions(mockGetUserUseCase);
      },
    );
  });
}
