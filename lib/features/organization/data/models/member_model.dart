import 'package:forestMapApp/core/enums/organization_member_status.dart';
import 'package:forestMapApp/core/enums/organization_role_types.dart';

import '../../domain/entities/member.dart';

class MemberModel extends Member {
  MemberModel({
    id,
    name,
    email,
    avatarUrl,
    OrganizationMemberStatus status,
    OrganizationRoleType role,
  }) : super(
          id: id,
          name: name,
          email: email,
          avatarUrl: avatarUrl,
          status: status,
          role: role,
        );

  factory MemberModel.fromMap(Map<String, dynamic> map) {
    return MemberModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      avatarUrl: map['avatarUrl'],
      status: OrganizationMemberStatus.values[map['status'] as int],
      role: OrganizationRoleType.values[map['role'] as int],
    );
  }

  Map<String, dynamic> toMap() => {
        'id': this.id,
        'name': this.name,
        'email': this.email,
        'avatarUrl': this.avatarUrl,
        'status': this.status,
        'role': this.role,
      };
}
