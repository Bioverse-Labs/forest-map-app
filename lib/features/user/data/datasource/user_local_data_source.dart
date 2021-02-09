import 'package:meta/meta.dart';

import '../../../../core/adapters/hive_adapter.dart';
import '../hive/user.dart';
import '../models/user_model.dart';

abstract class UserLocalDataSource {
  Future<UserModel> getUser(String id);
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
}
