import 'package:uuid/uuid.dart';

class UUIDGenerator {
  final Uuid? uuid;

  UUIDGenerator(this.uuid);

  String generateUID() => uuid!.v4();
}
