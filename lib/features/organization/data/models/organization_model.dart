import 'package:meta/meta.dart';

import '../../domain/entities/member.dart';
import '../../domain/entities/organization.dart';

class OrganizationModel extends Organization {
  OrganizationModel({
    @required id,
    @required name,
    @required email,
    phone,
    avatarUrl,
    List<Member> members,
  }) : super(
          id: id,
          name: name,
          email: email,
          phone: phone,
          avatarUrl: avatarUrl,
          members: members,
        );

  factory OrganizationModel.fromMap(Map<String, dynamic> map) {
    return OrganizationModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      avatarUrl: map['avatarUrl'],
      members: map['members'],
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'avatarUrl': avatarUrl,
      };

  OrganizationModel copyWith({
    id,
    name,
    email,
    phone,
    avatarUrl,
    members,
  }) =>
      OrganizationModel(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        members: members ?? this.members,
      );
}
