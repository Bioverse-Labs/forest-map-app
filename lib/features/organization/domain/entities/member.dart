import '../../../../core/enums/organization_member_status.dart';
import '../../../../core/enums/organization_role_types.dart';
import '../../../user/domain/entities/user.dart';

class Member extends User {
  final OrganizationMemberStatus? status;
  final OrganizationRoleType? role;

  Member({
    required id,
    required name,
    email,
    avatarUrl,
    required this.status,
    required this.role,
  }) : super(
          id: id,
          name: name,
          email: email,
          avatarUrl: avatarUrl,
        );
}
