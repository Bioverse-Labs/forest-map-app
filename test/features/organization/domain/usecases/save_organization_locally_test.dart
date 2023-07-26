import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forest_map/features/organization/domain/entities/organization.dart';
import 'package:forest_map/features/organization/domain/repositories/organization_repository.dart';
import 'package:forest_map/features/organization/domain/usecases/save_organization_locally.dart';
import 'package:mockito/mockito.dart';

class MockOrganizationRepository extends Mock
    implements OrganizationRepository {}

void main() {
  MockOrganizationRepository mockOrganizationRepository;
  SaveOrganizationLocally useCase;

  setUp(() {
    mockOrganizationRepository = MockOrganizationRepository();
    useCase = SaveOrganizationLocally(mockOrganizationRepository);
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

  test(
    'should return [Organization] when repository succeed',
    () async {
      when(mockOrganizationRepository.saveOrganizationLocally(
        id: anyNamed('id'),
        organization: anyNamed('organization'),
      )).thenAnswer((_) async => Right(tOrganization));

      await useCase(SaveOrganizationLocallyParams(
        id: tOrganization.id,
        organization: tOrganization,
      ));

      verify(mockOrganizationRepository.saveOrganizationLocally(
        id: tOrganization.id,
        organization: tOrganization,
      ));
      verifyNoMoreInteractions(mockOrganizationRepository);
    },
  );
}
