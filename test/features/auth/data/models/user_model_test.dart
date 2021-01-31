import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forestMapApp/features/auth/domain/entities/user.dart';
import 'package:forestMapApp/features/auth/data/models/user_model.dart';

void main() {
  final userId = faker.guid.guid();
  final name = faker.person.name();
  final email = faker.internet.email();
  final avatarUrl = faker.internet.uri('protocol');

  final tUserModel = UserModel(
    id: userId,
    name: name,
    email: email,
    avatarUrl: avatarUrl,
  );

  test('should be subclass of User entity', () async {
    expect(tUserModel, isA<User>());
  });

  group('fromMap', () {
    test('should return a valid model when the map is valid', () {
      final map = {
        'id': userId,
        'name': name,
        'email': email,
        'avatarUrl': avatarUrl,
      };

      final result = UserModel.fromMap(map);
      expect(result, tUserModel);
    });

    test('should throw error if required fields are missing', () {
      final map = {
        'email': email,
        'avatarUrl': avatarUrl,
      };

      expect(() => UserModel.fromMap(map), throwsAssertionError);
    });
  });

  group('toMap', () {
    test('should return map with user data', () {
      final Map<String, dynamic> map = {
        'id': userId,
        'name': name,
        'email': email,
        'avatarUrl': avatarUrl,
      };

      final result = tUserModel.toMap();

      expect(result, map);
    });
  });
}
