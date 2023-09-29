import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forest_map/core/util/uuid_generator.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:uuid/uuid.dart';

import 'uuid_generator_test.mocks.dart';

@GenerateMocks([Uuid])
void main() {
  late MockUuid mockUUID;
  late UUIDGenerator uuidGenerator;

  setUp(() {
    mockUUID = MockUuid();
    uuidGenerator = UUIDGenerator(mockUUID);
  });

  final tId = faker.guid.guid();

  test('should return unique id', () {
    when(mockUUID.v4()).thenReturn(tId);

    final result = uuidGenerator.generateUID();

    expect(result, tId);
  });
}
