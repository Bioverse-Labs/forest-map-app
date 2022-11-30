import 'package:equatable/equatable.dart';
import '../../../catalog/domain/entities/catalog.dart';
import 'package:meta/meta.dart';

import '../../../tracking/domain/entities/location.dart';

class Post extends Equatable {
  final String id;
  final String userId;
  final String organizationId;
  final String imageUrl;
  final DateTime timestamp;
  final Location location;
  final Catalog category;

  Post({
    @required this.id,
    @required this.imageUrl,
    @required this.timestamp,
    @required this.location,
    @required this.userId,
    @required this.organizationId,
    @required this.category,
  });

  @override
  List<Object> get props => [
        id,
        userId,
        organizationId,
        imageUrl,
        timestamp,
        location,
        category,
      ];
}
