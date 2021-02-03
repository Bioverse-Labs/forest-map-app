import 'package:meta/meta.dart';

import '../../../auth/domain/entities/user.dart';

class Organization {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatarUrl;
  final List<User> members;

  Organization({
    @required this.id,
    @required this.name,
    @required this.email,
    this.phone,
    this.avatarUrl,
    this.members,
  });
}
