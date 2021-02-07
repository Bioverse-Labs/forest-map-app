import 'package:meta/meta.dart';

import '../../../organization/domain/entities/organization.dart';
import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    @required String id,
    @required String name,
    String email,
    String avatarUrl,
    List<Organization> organizations,
  })  : assert(id != null),
        assert(name != null),
        super(
          id: id,
          name: name,
          email: email,
          organizations: organizations,
          avatarUrl: avatarUrl,
        );

  factory UserModel.fromMap(Map<String, dynamic> map) {
    assert(map['id'] != null);
    assert(map['name'] != null);

    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      organizations: map['organizations'],
      avatarUrl: map['avatarUrl'],
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'organizations': organizations?.map((e) => e.id)?.toList() ?? [],
        'avatarUrl': avatarUrl,
      };

  UserModel copyWith({
    String id,
    String name,
    String email,
    String avatarUrl,
    List<Organization> organizations,
  }) =>
      UserModel(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        organizations: organizations ?? this.organizations,
      );
}
