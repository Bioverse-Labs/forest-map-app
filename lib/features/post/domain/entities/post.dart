import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../tracking/domain/entities/location.dart';

class Post extends Equatable {
  final String id;
  final String userId;
  final String organizationId;
  final String specie;
  final String imageUrl;
  final DateTime timestamp;
  final Location location;

  Post({
    @required this.id,
    @required this.specie,
    @required this.imageUrl,
    @required this.timestamp,
    @required this.location,
    @required this.userId,
    @required this.organizationId,
  });

  @override
  List<Object> get props => [
        id,
        specie,
        userId,
        organizationId,
        imageUrl,
        timestamp,
        location,
      ];
}
