import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forest_map/features/organization/domain/entities/organization.dart';
import 'package:forest_map/features/organization/domain/repositories/organization_repository.dart';
import 'package:forest_map/features/organization/domain/usecases/get_organization.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_organization_test.mocks.dart';

@GenerateMocks([OrganizationRepository])
void main() {
  late MockOrganizationRepository mockOrganizationRepository;
  late GetOrganization useCase;

  setUp(() {
    mockOrganizationRepository = MockOrganizationRepository();
    useCase = GetOrganization(mockOrganizationRepository);
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
      when(mockOrganizationRepository.getOrganization(
        id: anyNamed('id'),
        searchLocally: anyNamed('searchLocally'),
      )).thenAnswer((_) async => Right(tOrganization));

      final result = await useCase(GetOrganizationParams(
        id: tId,
        searchLocally: false,
      ));

      expect(result, Right(tOrganization));
      verify(mockOrganizationRepository.getOrganization(
        id: tId,
        searchLocally: false,
      ));
      verifyNoMoreInteractions(mockOrganizationRepository);
    },
  );
}
