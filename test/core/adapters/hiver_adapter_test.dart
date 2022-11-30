import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forest_map_app/core/adapters/hive_adapter.dart';
import 'package:forest_map_app/core/errors/exceptions.dart';
import 'package:forest_map_app/features/user/data/hive/user.dart';
import 'package:hive/hive.dart';
import 'package:mockito/mockito.dart';

class MockLazyBox extends Mock implements LazyBox<UserHive> {}

class MockHiveInterface extends Mock implements HiveInterface {}

void main() {
  MockLazyBox mockLazyBox;
  MockHiveInterface mockHiveInterface;
  HiveAdapter<UserHive> hiveAdapter;

  setUp(() {
    mockLazyBox = MockLazyBox();
    mockHiveInterface = MockHiveInterface();
    when(mockHiveInterface.openLazyBox<UserHive>(any)).thenAnswer(
      (_) async => mockLazyBox,
    );
    hiveAdapter = HiveAdapter<UserHive>('user', mockHiveInterface);
  });

  final tId = faker.guid.guid();
  final tUser = UserHive()
    ..id = tId
    ..name = faker.person.name()
    ..email = faker.internet.email();

  group('get', () {
    test(
      'should return [UserHive]',
      () async {
        await hiveAdapter.init();
        when(mockLazyBox.get(any)).thenAnswer((_) async => tUser);

        final result = await hiveAdapter.get(tId);

        expect(result, tUser);
        verify(mockLazyBox.get(tId));
        verifyNoMoreInteractions(mockLazyBox);
      },
    );

    test(
      'should throw [LocalException] if hive fails',
      () async {
        await hiveAdapter.init();
        when(mockLazyBox.get(any)).thenThrow(HiveError(
          faker.randomGenerator.string(20),
        ));

        final call = hiveAdapter.get;

        expect(() => call(tId), throwsA(isInstanceOf<LocalException>()));
        verify(mockLazyBox.get(tId));
        verifyNoMoreInteractions(mockLazyBox);
      },
    );
  });

  group('getKeys', () {
    test(
      'should return list keys',
      () async {
        await hiveAdapter.init();
        when(mockLazyBox.keys).thenReturn([tId]);

        final result = hiveAdapter.getKeys();

        expect(result, [tId]);
        verify(mockLazyBox.keys);
        verifyNoMoreInteractions(mockLazyBox);
      },
    );

    test(
      'should throw [LocalException] if hive fails',
      () async {
        await hiveAdapter.init();
        when(mockLazyBox.keys).thenThrow(HiveError(
          faker.randomGenerator.string(20),
        ));

        final call = hiveAdapter.getKeys;

        expect(() => call(), throwsA(isInstanceOf<LocalException>()));
        verify(mockLazyBox.keys);
        verifyNoMoreInteractions(mockLazyBox);
      },
    );
  });

  group('put', () {
    test(
      'should return save [User]',
      () async {
        await hiveAdapter.init();
        when(mockLazyBox.put(any, any)).thenAnswer((_) async => null);

        await hiveAdapter.put(tId, tUser);

        verify(mockLazyBox.put(tId, tUser));
        verifyNoMoreInteractions(mockLazyBox);
      },
    );

    test(
      'should throw [LocalException] if hive fails',
      () async {
        await hiveAdapter.init();
        when(mockLazyBox.put(any, any)).thenThrow(HiveError(
          faker.randomGenerator.string(20),
        ));

        final call = hiveAdapter.put;

        expect(() => call(tId, tUser), throwsA(isInstanceOf<LocalException>()));
        verify(mockLazyBox.put(tId, tUser));
        verifyNoMoreInteractions(mockLazyBox);
      },
    );
  });

  group('delete', () {
    test(
      'should return save [User]',
      () async {
        await hiveAdapter.init();
        when(mockLazyBox.delete(any)).thenAnswer((_) async => null);

        await hiveAdapter.delete(tId);

        verify(mockLazyBox.delete(tId));
        verifyNoMoreInteractions(mockLazyBox);
      },
    );

    test(
      'should throw [LocalException] if hive fails',
      () async {
        await hiveAdapter.init();
        when(mockLazyBox.delete(any)).thenThrow(HiveError(
          faker.randomGenerator.string(20),
        ));

        final call = hiveAdapter.delete;

        expect(() => call(tId), throwsA(isInstanceOf<LocalException>()));
        verify(mockLazyBox.delete(tId));
        verifyNoMoreInteractions(mockLazyBox);
      },
    );
  });

  group('deleteAll', () {
    test(
      'should return delete [User]',
      () async {
        await hiveAdapter.init();
        when(mockLazyBox.keys).thenReturn([tId]);
        when(mockLazyBox.delete(any)).thenAnswer((_) async => null);

        await hiveAdapter.deleteAll();

        verify(mockLazyBox.keys);
        verify(mockLazyBox.delete(tId));
        verifyNoMoreInteractions(mockLazyBox);
      },
    );

    test(
      'should throw [LocalException] if hive fails',
      () async {
        await hiveAdapter.init();
        when(mockLazyBox.keys).thenThrow(HiveError(
          faker.randomGenerator.string(20),
        ));

        final call = hiveAdapter.deleteAll;

        expect(() => call(), throwsA(isInstanceOf<LocalException>()));
        verify(mockLazyBox.keys);
        verifyNoMoreInteractions(mockLazyBox);
      },
    );
  });
}
