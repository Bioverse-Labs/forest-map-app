import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forest_map/features/organization/domain/entities/organization.dart';
import 'package:forest_map/features/organization/domain/repositories/organization_repository.dart';
import 'package:forest_map/features/organization/domain/usecases/update_organization.dart';
import 'package:mockito/mockito.dart';

class MockOrganizationRepository extends Mock
    implements OrganizationRepository {}

void main() {
  MockOrganizationRepository mockOrganizationRepository;
  UpdateOrganization useCase;

  setUp(() {
    mockOrganizationRepository = MockOrganizationRepository();
    useCase = UpdateOrganization(mockOrganizationRepository);
  });

  final tId = faker.guid.guid();
  final tName = faker.company.name();
  final tEmail = faker.internet.email();
  final tPhone = faker.randomGenerator.integer(9).toString();
  final tAvatar = File(faker.image.image());
  final tOrganization = Organization(
    id: tId,
    name: tName,
    email: tEmail,
    phone: tPhone,
    avatarUrl: tAvatar.path,
  );

  test(
    'should return [Organization] when repository succeed',
    () async {
      when(mockOrganizationRepository.updateOrganization(
        id: anyNamed('id'),
        name: anyNamed('name'),
        email: anyNamed('email'),
        phone: anyNamed('phone'),
        avatar: anyNamed('avatar'),
      )).thenAnswer((_) async => Right(tOrganization));

      final result = await useCase(UpdateOrganizationParams(
        id: tId,
        name: tName,
        email: tEmail,
        phone: tPhone,
        avatar: tAvatar,
      ));

      expect(result, Right(tOrganization));
      verify(mockOrganizationRepository.updateOrganization(
        id: tId,
        name: tName,
        email: tEmail,
        phone: tPhone,
        avatar: tAvatar,
      ));
      verifyNoMoreInteractions(mockOrganizationRepository);
    },
  );
}
