// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrganizationHiveAdapter extends TypeAdapter<OrganizationHive> {
  @override
  final int typeId = 2;

  @override
  OrganizationHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrganizationHive()
      ..id = fields[0] as String
      ..name = fields[1] as String
      ..email = fields[2] as String
      ..phone = fields[3] as String
      ..avatarUrl = fields[4] as String
      ..members = (fields[5] as List)?.cast<MemberHive>()
      ..geolocationData = (fields[6] as List)?.cast<String>();
  }

  @override
  void write(BinaryWriter writer, OrganizationHive obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(4)
      ..write(obj.avatarUrl)
      ..writeByte(5)
      ..write(obj.members)
      ..writeByte(6)
      ..write(obj.geolocationData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrganizationHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
