import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forest_map/core/util/uuid_generator.dart';
import 'package:mockito/mockito.dart';
import 'package:uuid/uuid.dart';

class MockUUID extends Mock implements Uuid {}

void main() {
  MockUUID mockUUID;
  UUIDGenerator uuidGenerator;

  setUp(() {
    mockUUID = MockUUID();
    uuidGenerator = UUIDGenerator(mockUUID);
  });

  final tId = faker.guid.guid();

  test('should return unique id', () {
    when(mockUUID.v4()).thenReturn(tId);

    final result = uuidGenerator.generateUID();

    expect(result, tId);
  });
}
