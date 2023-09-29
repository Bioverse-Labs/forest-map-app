import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/models/model.dart';
import '../../../catalog/data/catalog.dart';
import '../../../catalog/domain/entities/catalog.dart';
import '../../../tracking/data/models/location_model.dart';
import '../../../tracking/domain/entities/location.dart';
import '../../domain/entities/post.dart';
import '../hive/pending_post.dart';
import '../hive/post.dart';

class PostModel extends Post implements Model<PostModel, PostHive> {
  PostModel({
    required String? id,
    required String? imageUrl,
    required DateTime? timestamp,
    required Location location,
    required String? userId,
    required String? organizationId,
    String? specie,
    Catalog? category,
    int? dbh,
    String? landUse,
  }) : super(
          id: id,
          userId: userId,
          imageUrl: imageUrl,
          timestamp: timestamp,
          location: location,
          organizationId: organizationId,
          category: category,
          specie: specie,
          landUse: landUse,
          dbh: dbh,
        );

  factory PostModel.fromMap(Map<String, dynamic> map) {
    late DateTime timestamp;

    if (map['timestamp'] is DateTime) {
      timestamp = map['timestamp'] as DateTime;
    } else if (map['timestamp'] is Timestamp) {
      timestamp = (map['timestamp'] as Timestamp).toDate();
    } else {
      timestamp = DateTime.now();
    }

    return PostModel(
      id: map['id'],
      imageUrl: map['imageUrl'],
      timestamp: timestamp,
      location: Location(
        id: null,
        lat: map['lat']?.toDouble(),
        lng: map['lng']?.toDouble(),
        timestamp: null,
        accuracy: map['accuracy']?.toDouble(),
        altitude: map['altitude']?.toDouble(),
        floor: map['floor'],
        heading: map['heading']?.toDouble(),
        speed: map['speed']?.toDouble(),
        speedAccuracy: map['speedAccuracy']?.toDouble(),
      ),
      userId: map['userId'],
      dbh: map['dbh'],
      specie: map['specie'],
      organizationId: map['organizationId'],
      landUse: map['landUse'],
      category: map['categoryId'] != null
          ? catalogList[map['categoryId'] as num?]
          : null,
    );
  }

  factory PostModel.fromHive(dynamic postHive) {
    return PostModel(
      id: postHive.id,
      userId: postHive.userId,
      imageUrl: postHive.imageUrl,
      timestamp: postHive.timestamp,
      location: LocationModel.fromHive(postHive.location),
      organizationId: postHive.organizationId,
      category:
          postHive.categoryId != null ? catalogList[postHive.categoryId] : null,
      landUse: postHive.landUse,
      specie: postHive.specie,
      dbh: postHive.dbh,
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
      landUse: post.landUse,
      specie: post.specie,
      dbh: post.dbh,
    );
  }

  @override
  PostModel copyWith({
    String? id,
    String? imageUrl,
    DateTime? timestamp,
    Location? location,
    String? userId,
    String? organizationId,
    Catalog? category,
    String? landUse,
    String? specie,
    int? dbh,
  }) {
    return PostModel(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      timestamp: timestamp ?? this.timestamp,
      location: location ?? this.location,
      userId: userId ?? this.userId,
      organizationId: organizationId ?? this.organizationId,
      category: category ?? this.category,
      landUse: landUse ?? this.landUse,
      dbh: dbh ?? this.dbh,
      specie: specie ?? this.specie,
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
      ..categoryId = category?.id
      ..organizationId = organizationId
      ..dbh = dbh
      ..landUse = landUse
      ..specie = category?.scientificName;
  }

  PendingPostHive toPendingPostHiveAdapter() {
    return PendingPostHive()
      ..id = id
      ..userId = userId
      ..imageUrl = imageUrl
      ..timestamp = timestamp
      ..location = LocationModel.fromEntity(location).toHiveAdapter()
      ..categoryId = category?.id
      ..organizationId = organizationId
      ..dbh = dbh
      ..landUse = landUse
      ..specie = category?.scientificName;
  }

  @override
  Map<String, dynamic> toMap() => {
        ...LocationModel.fromEntity(location).toMap(),
        'id': id,
        'specie': category?.scientificName,
        'name': category?.name,
        'imageUrl': imageUrl,
        'timestamp': Timestamp.fromDate(timestamp ?? DateTime.now()),
        'userId': userId,
        'categoryId': category?.id,
        'landUse': landUse,
        'dbh': dbh,
      };
}
