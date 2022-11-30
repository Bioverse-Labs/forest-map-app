import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forest_map_app/features/user/domain/entities/user.dart';
import 'package:forest_map_app/features/organization/domain/entities/organization.dart';
import 'package:forest_map_app/features/organization/domain/repositories/organization_repository.dart';
import 'package:forest_map_app/features/organization/domain/usecases/add_member.dart';
import 'package:mockito/mockito.dart';

class MockOrganizationRepository extends Mock
    implements OrganizationRepository {}

void main() {
  MockOrganizationRepository mockOrganizationRepository;
  AddMember useCase;

  setUp(() {
    mockOrganizationRepository = MockOrganizationRepository();
    useCase = AddMember(mockOrganizationRepository);
  });

  final tId = faker.guid.guid();
  final tName = faker.company.name();
  final tEmail = faker.internet.email();
  final tPhone = faker.randomGenerator.integer(9).toString();
  final tOrganization = Organization(
    id: tId,
    name: tName,
    email: tEmail,
    phone: tPhone,
    avatarUrl: faker.image.image(),
  );
  final tUser = User(id: faker.guid.guid(), name: faker.person.name());

  test(
    'should return [Organization] when repository succeed',
    () async {
      when(mockOrganizationRepository.addMember(
        id: anyNamed('id'),
        user: anyNamed('user'),
      )).thenAnswer((_) async => Right(tOrganization));

      final result = await useCase(AddMemberParams(
        id: tId,
        user: tUser,
      ));

      expect(result, Right(tOrganization));
      verify(mockOrganizationRepository.addMember(
        id: tId,
        user: tUser,
      ));
      verifyNoMoreInteractions(mockOrganizationRepository);
    },
  );
}
