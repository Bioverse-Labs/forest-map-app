import '../../../../core/models/model.dart';
import '../../domain/entities/member.dart';
import '../../domain/entities/organization.dart';
import '../hive/organization.dart';
import 'member_model.dart';

class OrganizationModel extends Organization
    implements Model<OrganizationModel, OrganizationHive> {
  OrganizationModel({
    required id,
    required name,
    required email,
    phone,
    avatarUrl,
    List<Member>? members,
    List<String>? geolocationData,
  }) : super(
          id: id,
          name: name,
          email: email,
          phone: phone,
          avatarUrl: avatarUrl,
          members: members,
          geolocationData: geolocationData,
        );

  factory OrganizationModel.fromMap(Map<String, dynamic> map) {
    return OrganizationModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      avatarUrl: map['avatarUrl'],
      members: map['members'],
      geolocationData: map['geolocationData'] as List<String>?,
    );
  }

  factory OrganizationModel.fromHive(OrganizationHive orgHive) {
    final _members =
        orgHive.members?.map((member) => MemberModel.fromHive(member)).toList();

    return OrganizationModel(
      id: orgHive.id,
      name: orgHive.name,
      email: orgHive.email,
      phone: orgHive.phone,
      avatarUrl: orgHive.avatarUrl,
      members: _members,
      geolocationData: orgHive.geolocationData,
    );
  }

  factory OrganizationModel.fromEntity(Organization organization) {
    return OrganizationModel(
      id: organization.id,
      name: organization.name,
      email: organization.email,
      phone: organization.phone,
      avatarUrl: organization.avatarUrl,
      members: organization.members,
      geolocationData: organization.geolocationData,
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'avatarUrl': avatarUrl,
      };

  @override
  OrganizationHive toHiveAdapter() {
    return OrganizationHive()
      ..id = id
      ..name = name
      ..email = email
      ..phone = phone
      ..avatarUrl = avatarUrl
      ..members = members
              ?.map((member) => MemberModel.fromEntity(member).toHiveAdapter())
              .toList() ??
          []
      ..geolocationData = geolocationData;
  }

  @override
  OrganizationModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    List<Member>? members,
    List<String>? geolocationData,
  }) =>
      OrganizationModel(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        members: members ?? this.members,
        geolocationData: geolocationData ?? this.geolocationData,
      );
}
