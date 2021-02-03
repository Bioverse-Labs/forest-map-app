import 'package:meta/meta.dart';

import '../../../auth/domain/entities/user.dart';
import '../../domain/entities/organization.dart';

class OrganizationModel extends Organization {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatarUrl;
  final List<User> members;

  OrganizationModel({
    @required this.id,
    @required this.name,
    @required this.email,
    this.phone,
    this.avatarUrl,
    this.members,
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
}
