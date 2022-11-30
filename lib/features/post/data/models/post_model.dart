import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../catalog/data/catalog.dart';
import '../../../catalog/domain/entities/catalog.dart';
import '../hive/pending_post.dart';
import 'package:meta/meta.dart';

import '../../../../core/models/model.dart';
import '../../../tracking/data/models/location_model.dart';
import '../../../tracking/domain/entities/location.dart';
import '../../domain/entities/post.dart';
import '../hive/post.dart';

class PostModel extends Post implements Model<PostModel, PostHive> {
  PostModel({
    @required String id,
    @required String imageUrl,
    @required DateTime timestamp,
    @required Location location,
    @required String userId,
    @required String organizationId,
    @required Catalog category,
  }) : super(
          id: id,
          userId: userId,
          imageUrl: imageUrl,
          timestamp: timestamp,
          location: location,
          organizationId: organizationId,
          category: category,
        );

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
        id: map['id'],
        imageUrl: map['imageUrl'],
        timestamp: (map['timestamp'] as Timestamp).toDate(),
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
        category: catalogList[map['categoryId'] as num]);
  }

  factory PostModel.fromHive(dynamic postHive) {
    return PostModel(
      id: postHive.id,
      userId: postHive.userId,
      imageUrl: postHive.imageUrl,
      timestamp: postHive.timestamp,
      location: LocationModel.fromHive(postHive.location),
      organizationId: postHive.organizationId,
      category: catalogList[postHive.categoryId],
    );
  }

  factory PostModel.fromEntity(Post post) {
    return PostModel(
      id: post.id,
      userId: post.userId,
      organizationId: post.organizationId,
      imageUrl: post.imageUrl,
      timestamp: post.timestamp,
      location: post.location,
      category: post.category,
    );
  }

  @override
  PostModel copyWith({
    String id,
    String imageUrl,
    DateTime timestamp,
    Location location,
    String userId,
    String organizationId,
    Catalog category,
  }) {
    return PostModel(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      timestamp: timestamp ?? this.timestamp,
      location: location ?? this.location,
      userId: userId ?? this.userId,
      organizationId: organizationId ?? this.organizationId,
      category: category ?? this.category,
    );
  }

  @override
  PostHive toHiveAdapter() {
    return PostHive()
      ..id = id
      ..userId = userId
      ..imageUrl = imageUrl
      ..timestamp = timestamp
      ..location = LocationModel.fromEntity(location).toHiveAdapter()
      ..categoryId = category.id
      ..organizationId = organizationId
      ..specie = category.scientificName;
  }

  PendingPostHive toPendingPostHiveAdapter() {
    return PendingPostHive()
      ..id = id
      ..userId = userId
      ..imageUrl = imageUrl
      ..timestamp = timestamp
      ..location = LocationModel.fromEntity(location).toHiveAdapter()
      ..categoryId = category.id
      ..organizationId = organizationId
      ..specie = category.scientificName;
  }

  @override
  Map<String, dynamic> toMap() => {
        ...LocationModel.fromEntity(location).toMap(),
        'id': id,
        'specie': category.scientificName,
        'name': category.name,
        'imageUrl': imageUrl,
        'timestamp': Timestamp.fromDate(timestamp),
        'userId': userId,
        'categoryId': category.id,
        ...(location as LocationModel).toMap(),
      };
}
