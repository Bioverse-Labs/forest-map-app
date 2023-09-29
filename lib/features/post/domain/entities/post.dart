import 'package:equatable/equatable.dart';
import '../../../catalog/domain/entities/catalog.dart';

import '../../../tracking/domain/entities/location.dart';

class Post extends Equatable {
  final String? id;
  final String? userId;
  final String? organizationId;
  final String? imageUrl;
  final DateTime? timestamp;
  final Location location;
  final Catalog? category;
  final String? landUse;
  final String? specie;
  final int? dbh;

  Post({
    required this.id,
    required this.imageUrl,
    required this.timestamp,
    required this.location,
    required this.userId,
    required this.organizationId,
    this.specie,
    this.category,
    this.landUse,
    this.dbh,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        organizationId,
        imageUrl,
        timestamp,
        location,
        category,
        landUse,
        specie,
        dbh,
      ];
}
