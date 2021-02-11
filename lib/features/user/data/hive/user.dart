import 'package:hive/hive.dart';

import '../../../organization/data/hive/organization.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class UserHive {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String email;

  @HiveField(3)
  String avatarUrl;

  @HiveField(4)
  List<OrganizationHive> organizations;
}
