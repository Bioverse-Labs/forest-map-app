import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forest_map/features/organization/data/hive/organization.dart';
import 'package:forest_map/features/organization/data/models/organization_model.dart';

void main() {
  final tId = faker.guid.guid();
  final tName = faker.company.name();
  final tEmail = faker.internet.email();
  final tPhone = faker.randomGenerator.integer(9).toString();
  final tAvatar = faker.image.image();

  final tMap = {
    'id': tId,
    'name': tName,
    'email': tEmail,
    'phone': tPhone,
    'avatarUrl': tAvatar,
  };

  final tOrganizationHive = OrganizationHive()
    ..id = tId
    ..name = tName
    ..email = tEmail
    ..phone = tPhone
    ..avatarUrl = tAvatar
    ..members = [];

  final tOrganizationModel = OrganizationModel(
    id: tId,
    name: tName,
    email: tEmail,
    phone: tPhone,
    avatarUrl: tAvatar,
  );

  test(
    'should return [OrganizationModel] if map is valid',
    () async {
      final model = OrganizationModel.fromMap(tMap);

      expect(model, isInstanceOf<OrganizationModel>());
    },
  );

  test(
    'should return [OrganizationModel] if [OrganizationHive] is valid',
    () async {
      final model = OrganizationModel.fromHive(tOrganizationHive);

      expect(model, isInstanceOf<OrganizationModel>());
    },
  );

  test(
    'should return [Map<String, dynamic> map] from model',
    () async {
      final map = tOrganizationModel.toMap();

      expect(map, tMap);
    },
  );

  test(
    'should return new instance of [OrganizationModel] ',
    () async {
      final model = tOrganizationModel.copyWith(name: faker.company.name());

      expect(model, isNot(tOrganizationModel));
    },
  );
}
