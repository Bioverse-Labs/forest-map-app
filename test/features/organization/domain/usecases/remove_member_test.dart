import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forest_map/features/organization/domain/entities/organization.dart';
import 'package:forest_map/features/organization/domain/repositories/organization_repository.dart';
import 'package:forest_map/features/organization/domain/usecases/remove_member.dart';
import 'package:mockito/mockito.dart';

class MockOrganizationRepository extends Mock
    implements OrganizationRepository {}

void main() {
  MockOrganizationRepository mockOrganizationRepository;
  RemoveMember useCase;

  setUp(() {
    mockOrganizationRepository = MockOrganizationRepository();
    useCase = RemoveMember(mockOrganizationRepository);
  });

  final tId = faker.guid.guid();
  final tUserId = faker.guid.guid();
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

  test(
    'should return [Organization] when repository succeed',
    () async {
      when(mockOrganizationRepository.removeMember(
        id: anyNamed('id'),
        userId: anyNamed('userId'),
      )).thenAnswer((_) async => Right(tOrganization));

      final result = await useCase(RemoveMemberParams(
        id: tId,
        userId: tUserId,
      ));

      expect(result, Right(tOrganization));
      verify(mockOrganizationRepository.removeMember(
        id: tId,
        userId: tUserId,
      ));
      verifyNoMoreInteractions(mockOrganizationRepository);
    },
  );
}
