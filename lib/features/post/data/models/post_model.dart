import 'package:meta/meta.dart';

import '../../../../core/models/model.dart';
import '../../../tracking/data/models/location_model.dart';
import '../../../tracking/domain/entities/location.dart';
import '../../domain/entities/post.dart';
import '../hive/post.dart';

class PostModel extends Post implements Model<PostModel, PostHive> {
  PostModel({
    @required String id,
    @required String specie,
    @required String imageUrl,
    @required DateTime timestamp,
    @required Location location,
    @required String userId,
    @required String organizationId,
  }) : super(
          id: id,
          userId: userId,
          specie: specie,
          imageUrl: imageUrl,
          timestamp: timestamp,
          location: location,
          organizationId: organizationId,
        );

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'],
      specie: map['specie'],
      imageUrl: map['imageUrl'],
      timestamp: map['timestamp'],
      location: Location(
        id: null,
        lat: map['lat'],
        lng: map['lng'],
        timestamp: null,
        accuracy: map['accuracy'],
        altitude: map['altitude'],
        floor: map['floor'],
        heading: map['heading'],
        speed: map['speed'],
        speedAccuracy: map['speedAccuracy'],
      ),
      userId: map['userId'],
      organizationId: map['organizationId'],
    );
  }

  factory PostModel.fromHive(PostHive postHive) {
    return PostModel(
      id: postHive.id,
      userId: postHive.userId,
      specie: postHive.specie,
      imageUrl: postHive.imageUrl,
      timestamp: postHive.timestamp,
      location: LocationModel.fromHive(postHive.location),
      organizationId: postHive.organizationId,
    );
  }

  factory PostModel.fromEntity(Post post) {
    return PostModel(
      id: post.id,
      userId: post.userId,
      organizationId: post.organizationId,
      specie: post.specie,
      imageUrl: post.imageUrl,
      timestamp: post.timestamp,
      location: post.location,
    );
  }

  @override
  PostModel copyWith({
    String id,
    String specie,
    String imageUrl,
    DateTime timestamp,
    Location location,
    String userId,
    String organizationId,
  }) {
    return PostModel(
      id: id ?? this.id,
      specie: specie ?? this.specie,
      imageUrl: imageUrl ?? this.imageUrl,
      timestamp: timestamp ?? this.timestamp,
      location: location ?? this.location,
      userId: userId ?? this.userId,
      organizationId: organizationId ?? this.organizationId,
    );
  }

  @override
  PostHive toHiveAdapter() {
    return PostHive()
      ..id = id
      ..specie = specie
      ..userId = userId
      ..imageUrl = imageUrl
      ..timestamp = timestamp
      ..location = LocationModel.fromEntity(location).toHiveAdapter();
  }

  @override
  Map<String, dynamic> toMap() => {
        ...LocationModel.fromEntity(location).toMap(),
        'id': id,
        'specie': specie,
        'imageUrl': imageUrl,
        'timestamp': timestamp,
        'userId': userId,
      };
}
