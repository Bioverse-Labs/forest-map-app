import 'package:meta/meta.dart';

import '../../../../core/models/model.dart';
import '../../../organization/data/models/organization_model.dart';
import '../../../organization/domain/entities/organization.dart';
import '../../domain/entities/user.dart';
import '../hive/user.dart';

class UserModel extends User implements Model<UserModel, UserHive> {
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

  factory UserModel.fromHive(UserHive userHive) {
    return UserModel(
      id: userHive.id,
      name: userHive.name,
      email: userHive.email,
      avatarUrl: userHive.avatarUrl,
      organizations: userHive?.organizations
              ?.map((organization) => OrganizationModel.fromHive(organization))
              ?.toList() ??
          [],
    );
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      avatarUrl: user.avatarUrl,
      organizations: user.organizations,
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'organizations': organizations?.map((e) => e.id)?.toList() ?? [],
        'avatarUrl': avatarUrl,
      };

  @override
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

  @override
  UserHive toHiveAdapter() {
    return UserHive()
      ..id = id
      ..name = name
      ..email = email
      ..avatarUrl = avatarUrl
      ..organizations = organizations
              ?.map(
                (organization) =>
                    OrganizationModel.fromEntity(organization).toHiveAdapter(),
              )
              ?.toList() ??
          [];
  }
}
