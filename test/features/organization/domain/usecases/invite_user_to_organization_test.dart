import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forestMapApp/features/user/domain/entities/user.dart';
import 'package:forestMapApp/features/organization/domain/entities/organization.dart';
import 'package:forestMapApp/features/organization/domain/repositories/organization_repository.dart';
import 'package:forestMapApp/features/organization/domain/usecases/invite_user_to_organization.dart';
import 'package:mockito/mockito.dart';

class MockOrganizationRepository extends Mock
    implements OrganizationRepository {}

void main() {
  MockOrganizationRepository mockOrganizationRepository;
  InviteUserToOrganization useCase;

  setUp(() {
    mockOrganizationRepository = MockOrganizationRepository();
    useCase = InviteUserToOrganization(mockOrganizationRepository);
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
      when(mockOrganizationRepository.inviteUserToOrganization(
        id: anyNamed('id'),
        user: anyNamed('user'),
      )).thenAnswer((_) async => Right(tOrganization));

      final result = await useCase(InviteUserToOrganizationParams(
        id: tId,
        user: tUser,
      ));

      expect(result, Right(tOrganization));
      verify(mockOrganizationRepository.inviteUserToOrganization(
        id: tId,
        user: tUser,
      ));
      verifyNoMoreInteractions(mockOrganizationRepository);
    },
  );
}
