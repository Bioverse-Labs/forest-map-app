// ! DO NOT CHANGE ENUM'S ORDER

import 'package:hive/hive.dart';

part 'organization_role_types.g.dart';

@HiveType(typeId: 100)
enum OrganizationRoleType {
  @HiveField(0)
  member,
  @HiveField(1)
  admin,
  @HiveField(2)
  owner,
}
