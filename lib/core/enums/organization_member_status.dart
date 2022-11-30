// ! DO NOT CHANGE ENUM'S ORDER

import 'package:hive/hive.dart';

part 'organization_member_status.g.dart';

@HiveType(typeId: 101)
enum OrganizationMemberStatus {
  @HiveField(0)
  removed,
  @HiveField(1)
  disabled,
  @HiveField(2)
  pending,
  @HiveField(3)
  active,
}
