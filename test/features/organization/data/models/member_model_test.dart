import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forestMapApp/core/enums/organization_member_status.dart';
import 'package:forestMapApp/core/enums/organization_role_types.dart';
import 'package:forestMapApp/features/organization/data/hive/member.dart';
import 'package:forestMapApp/features/organization/data/models/member_model.dart';

void main() {
  final tId = faker.guid.guid();
  final tName = faker.person.name();
  final tEmail = faker.internet.email();
  final tAvatar = faker.image.image();

  final tMap = {
    'id': tId,
    'name': tName,
    'email': tEmail,
    'avatarUrl': tAvatar,
    'status': OrganizationMemberStatus.active.index,
    'role': OrganizationRoleType.member.index,
  };

  final tMemberHive = MemberHive()
    ..id = tId
    ..name = tName
    ..email = tEmail
    ..avatarUrl = tAvatar;

  final tMemberModel = MemberModel(
    id: tId,
    name: tName,
    email: tEmail,
    avatarUrl: tAvatar,
    status: OrganizationMemberStatus.active,
    role: OrganizationRoleType.member,
  );

  test(
    'should return [MemberModel] if map is valid',
    () async {
      final model = MemberModel.fromMap(tMap);

      expect(model, isInstanceOf<MemberModel>());
    },
  );

  test(
    'should return [MemberModel] if [MemberHive] is valid',
    () async {
      final model = MemberModel.fromHive(tMemberHive);

      expect(model, isInstanceOf<MemberModel>());
    },
  );

  test(
    'should return [Map<String, dynamic> map] from model',
    () async {
      final map = tMemberModel.toMap();

      expect(map, tMap);
    },
  );
}
