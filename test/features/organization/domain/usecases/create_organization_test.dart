import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forest_map_app/features/user/domain/entities/user.dart';
import 'package:forest_map_app/features/organization/domain/entities/organization.dart';
import 'package:forest_map_app/features/organization/domain/repositories/organization_repository.dart';
import 'package:forest_map_app/features/organization/domain/usecases/create_organization.dart';
import 'package:mockito/mockito.dart';

class MockOrganizationRepository extends Mock
    implements OrganizationRepository {}

void main() {
  MockOrganizationRepository mockOrganizationRepository;
  CreateOrganization useCase;

  setUp(() {
    mockOrganizationRepository = MockOrganizationRepository();
    useCase = CreateOrganization(mockOrganizationRepository);
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
  final tUser = User(id: faker.guid.guid(), name: faker.person.name());

  test(
    'should return [Organization] when repository succeed',
    () async {
      when(mockOrganizationRepository.createOrganization(
        user: anyNamed('user'),
        name: anyNamed('name'),
        email: anyNamed('email'),
        phone: anyNamed('phone'),
        avatar: anyNamed('avatar'),
      )).thenAnswer((_) async => Right(tOrganization));

      final result = await useCase(CreateOrganizationParams(
        user: tUser,
        name: tName,
        email: tEmail,
        phone: tPhone,
        avatar: tAvatar,
      ));

      expect(result, Right(tOrganization));
      verify(mockOrganizationRepository.createOrganization(
        user: tUser,
        name: tName,
        email: tEmail,
        phone: tPhone,
        avatar: tAvatar,
      ));
      verifyNoMoreInteractions(mockOrganizationRepository);
    },
  );
}
