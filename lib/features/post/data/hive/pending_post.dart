import 'package:hive/hive.dart';

import '../../../tracking/data/hive/location.dart';

part 'pending_post.g.dart';

@HiveType(typeId: 6)
class PendingPostHive {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? userId;

  @HiveField(2)
  String? organizationId;

  @HiveField(3)
  String? specie;

  @HiveField(4)
  String? imageUrl;

  @HiveField(5)
  DateTime? timestamp;

  @HiveField(6)
  LocationHive? location;

  @HiveField(7)
  int? categoryId;

  @HiveField(8)
  int? dbh;

  @HiveField(9)
  String? landUse;
}
