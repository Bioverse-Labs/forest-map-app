import 'package:hive/hive.dart';

import '../../../../core/enums/organization_member_status.dart';
import '../../../../core/enums/organization_role_types.dart';

part 'member.g.dart';

@HiveType(typeId: 3)
class MemberHive {
  @HiveField(0)
  String name;

  @HiveField(1)
  String email;

  @HiveField(2)
  String avatarUrl;

  @HiveField(3)
  OrganizationMemberStatus status;

  @HiveField(4)
  OrganizationRoleType role;
}
