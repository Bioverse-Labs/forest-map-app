import 'package:meta/meta.dart';

import '../../../../core/adapters/hive_adapter.dart';
import '../../domain/entities/organization.dart';
import '../hive/organization.dart';
import '../models/organization_model.dart';

abstract class OrganizationLocalDataSource {
  Future<OrganizationModel> getOrganization(String id);
  Future<void> saveOrganization({
    String id,
    Organization organization,
  });
}

class OrganizationLocalDataSourceImpl implements OrganizationLocalDataSource {
  final HiveAdapter<OrganizationHive> orgHive;

  OrganizationLocalDataSourceImpl({
    @required this.orgHive,
  });

  @override
  Future<OrganizationModel> getOrganization(String id) async {
    final orgObject = await orgHive.get(id);

    if (orgObject != null) {
      return OrganizationModel.fromHive(orgObject);
    }

    return null;
  }

  @override
  Future<void> saveOrganization({
    @required String id,
    @required Organization organization,
  }) =>
      orgHive.put(
        id,
        OrganizationModel.fromEntity(organization).toHiveAdapter(),
      );
}
