import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forest_map_app/core/adapters/hive_adapter.dart';
import 'package:forest_map_app/features/organization/data/datasources/organization_local_data_source.dart';
import 'package:forest_map_app/features/organization/data/hive/organization.dart';
import 'package:forest_map_app/features/organization/data/models/organization_model.dart';
import 'package:mockito/mockito.dart';

class MockHiveAdapter extends Mock implements HiveAdapter<OrganizationHive> {}

void main() {
  MockHiveAdapter mockHiveAdapter;
  OrganizationLocalDataSourceImpl organizationLocalDataSource;

  setUp(() {
    mockHiveAdapter = MockHiveAdapter();
    organizationLocalDataSource = OrganizationLocalDataSourceImpl(
      orgHive: mockHiveAdapter,
    );
  });

  final tOrganizationHive = OrganizationHive()
    ..id = faker.guid.guid()
    ..name = faker.company.name()
    ..email = faker.internet.email();

  final tOrganiaztionModel = OrganizationModel.fromHive(tOrganizationHive);

  group('getOrganization', () {
    test(
      'should return [OrganizationModel]',
      () async {
        when(mockHiveAdapter.get(any)).thenAnswer(
          (_) async => tOrganizationHive,
        );

        final result = await organizationLocalDataSource.getOrganization(
          tOrganiaztionModel.id,
        );

        expect(result, tOrganiaztionModel);
        verify(mockHiveAdapter.get(tOrganiaztionModel.id));
        verifyNoMoreInteractions(mockHiveAdapter);
      },
    );
  });

  group('saveOrganization', () {
    test(
      'should save to storage',
      () async {
        when(mockHiveAdapter.put(any, any)).thenAnswer((_) => null);

        await organizationLocalDataSource.saveOrganization(
          id: tOrganiaztionModel.id,
          organization: tOrganiaztionModel,
        );

        verify(mockHiveAdapter.put(tOrganiaztionModel.id, any));
        verifyNoMoreInteractions(mockHiveAdapter);
      },
    );
  });
}
