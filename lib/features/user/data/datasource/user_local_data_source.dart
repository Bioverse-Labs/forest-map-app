import 'package:meta/meta.dart';

import '../../../../core/adapters/hive_adapter.dart';
import '../../domain/entities/user.dart';
import '../hive/user.dart';
import '../models/user_model.dart';

abstract class UserLocalDataSource {
  Future<UserModel> getUser(String id);
  Future<void> saveUser({
    String id,
    User user,
  });
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final HiveAdapter<UserHive> userHive;

  UserLocalDataSourceImpl({
    @required this.userHive,
  });

  @override
  Future<UserModel> getUser(String id) async {
    final userObject = await userHive.get(id);

    if (userObject != null) {
      return UserModel.fromHive(userObject);
    }

    return null;
  }

  @override
  Future<void> saveUser({String id, User user}) {
    return userHive.put(id, UserModel.fromEntity(user).toHiveAdapter());
  }
}
