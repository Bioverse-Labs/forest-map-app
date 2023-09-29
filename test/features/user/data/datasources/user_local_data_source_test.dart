import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forest_map/core/adapters/hive_adapter.dart';
import 'package:forest_map/features/user/data/datasource/user_local_data_source.dart';
import 'package:forest_map/features/user/data/hive/user.dart';
import 'package:forest_map/features/user/data/models/user_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'user_local_data_source_test.mocks.dart';

@GenerateMocks([HiveAdapter])
void main() {
  late MockHiveAdapter<UserHive> mockHiveAdapter;
  late UserLocalDataSourceImpl userLocalDataSourceImpl;

  setUp(() {
    mockHiveAdapter = MockHiveAdapter();
    userLocalDataSourceImpl = UserLocalDataSourceImpl(
      userHive: mockHiveAdapter,
    );
  });

  final tUserHive = UserHive()
    ..id = faker.guid.guid()
    ..name = faker.person.name()
    ..email = faker.internet.email()
    ..organizations = [];

  final tUserModel = UserModel(
    id: tUserHive.id!,
    name: tUserHive.name!,
    email: tUserHive.email,
    organizations: [],
  );

  test(
    'should return [UserModel]',
    () async {
      when(mockHiveAdapter.get(any)).thenAnswer(
        (_) async => tUserHive,
      );

      final result = await userLocalDataSourceImpl.getUser(
        tUserModel.id,
      );

      expect(result, tUserModel);
      verify(mockHiveAdapter.get(tUserModel.id));
      verifyNoMoreInteractions(mockHiveAdapter);
    },
  );

  group('saveOrganization', () {
    test(
      'should save to storage',
      () async {
        when(mockHiveAdapter.put(any, any)).thenAnswer((_) async => null);

        await userLocalDataSourceImpl.saveUser(
          id: tUserModel.id,
          user: tUserModel,
        );

        verify(mockHiveAdapter.put(tUserModel.id, any));
        verifyNoMoreInteractions(mockHiveAdapter);
      },
    );
  });
}
