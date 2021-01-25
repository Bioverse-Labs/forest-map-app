import 'package:meta/meta.dart';

import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    @required String id,
    @required String name,
    String email,
    String avatarUrl,
  })  : assert(id != null),
        assert(name != null),
        super(id: id, name: name, email: email, avatarUrl: avatarUrl);

  factory UserModel.fromMap(Map<String, dynamic> map) {
    assert(map['id'] != null);
    assert(map['name'] != null);

    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      avatarUrl: map['avatarUrl'],
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'avatarUrl': avatarUrl,
      };
}
