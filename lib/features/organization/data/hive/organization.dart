import 'package:hive/hive.dart';

import 'member.dart';

part 'organization.g.dart';

@HiveType(typeId: 2)
class OrganizationHive {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? email;

  @HiveField(3)
  String? phone;

  @HiveField(4)
  String? avatarUrl;

  @HiveField(5)
  List<MemberHive>? members;

  @HiveField(6)
  List<String>? geolocationData;
}
