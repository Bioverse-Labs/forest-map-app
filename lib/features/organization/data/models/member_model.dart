import '../../../../core/enums/organization_member_status.dart';
import '../../../../core/enums/organization_role_types.dart';
import '../../../../core/models/model.dart';
import '../../domain/entities/member.dart';
import '../hive/member.dart';

class MemberModel extends Member implements Model<MemberModel, MemberHive> {
  MemberModel({
    id,
    name,
    email,
    avatarUrl,
    OrganizationMemberStatus? status,
    OrganizationRoleType? role,
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
      status: map['status'] != null
          ? OrganizationMemberStatus.values[map['status'] as int]
          : null,
      role: map['role'] != null
          ? OrganizationRoleType.values[map['role'] as int]
          : null,
    );
  }

  factory MemberModel.fromHive(MemberHive memberHive) {
    return MemberModel(
      id: memberHive.id,
      name: memberHive.name,
      email: memberHive.email,
      avatarUrl: memberHive.avatarUrl,
      role: memberHive.role,
      status: memberHive.status,
    );
  }

  factory MemberModel.fromEntity(Member member) {
    return MemberModel(
      id: member.id,
      name: member.name,
      email: member.email,
      avatarUrl: member.avatarUrl,
      role: member.role,
      status: member.status,
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        'id': this.id,
        'name': this.name,
        'email': this.email,
        'avatarUrl': this.avatarUrl,
        'status': this.status!.index,
        'role': this.role!.index,
      };

  @override
  MemberHive toHiveAdapter() => MemberHive()
    ..id = id
    ..name = name
    ..email = email
    ..avatarUrl = avatarUrl
    ..role = role
    ..status = status;

  @override
  MemberModel copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    OrganizationMemberStatus? status,
    OrganizationRoleType? role,
  }) {
    return MemberModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      status: status ?? this.status,
      role: role ?? this.role,
    );
  }
}
