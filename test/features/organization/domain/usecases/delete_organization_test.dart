import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forestMapApp/features/organization/domain/entities/organization.dart';
import 'package:forestMapApp/features/organization/domain/repositories/organization_repository.dart';
import 'package:forestMapApp/features/organization/domain/usecases/delete_organization.dart';
import 'package:mockito/mockito.dart';

class MockOrganizationRepository extends Mock
    implements OrganizationRepository {}

void main() {
  MockOrganizationRepository mockOrganizationRepository;
  DeleteOrganization useCase;

  setUp(() {
    mockOrganizationRepository = MockOrganizationRepository();
    useCase = DeleteOrganization(mockOrganizationRepository);
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
      when(mockOrganizationRepository.deleteOrganization(any))
          .thenAnswer((_) async => Right(tOrganization));

      final result = await useCase(DeleteOrganizationParams(tId));

      expect(result, isInstanceOf<Right>());
      verify(mockOrganizationRepository.deleteOrganization(tId));
      verifyNoMoreInteractions(mockOrganizationRepository);
    },
  );
}
