// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MemberHiveAdapter extends TypeAdapter<MemberHive> {
  @override
  final int typeId = 3;

  @override
  MemberHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MemberHive()
      ..id = fields[0] as String
      ..name = fields[1] as String
      ..email = fields[2] as String
      ..avatarUrl = fields[3] as String
      ..status = fields[4] as OrganizationMemberStatus
      ..role = fields[5] as OrganizationRoleType;
  }

  @override
  void write(BinaryWriter writer, MemberHive obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.avatarUrl)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.role);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemberHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
