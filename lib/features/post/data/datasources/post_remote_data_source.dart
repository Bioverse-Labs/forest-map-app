import 'dart:io';

import 'package:forestMapApp/features/tracking/domain/entities/location.dart';

abstract class PostRemoteDataSource {
  Future<void> savePost({
    String organizationId,
    String userId,
    String specie,
    File file,
    DateTime timestamp,
    Location location,
  });
}
