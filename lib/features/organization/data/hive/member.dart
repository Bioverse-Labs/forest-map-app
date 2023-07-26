import 'package:hive/hive.dart';

import '../../../../core/enums/organization_member_status.dart';
import '../../../../core/enums/organization_role_types.dart';

part 'member.g.dart';

@HiveType(typeId: 3)
class MemberHive {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? email;

  @HiveField(3)
  String? avatarUrl;

  @HiveField(4)
  OrganizationMemberStatus? status;

  @HiveField(5)
  OrganizationRoleType? role;
}
