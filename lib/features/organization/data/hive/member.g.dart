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
      ..name = fields[0] as String
      ..email = fields[1] as String
      ..avatarUrl = fields[2] as String
      ..status = fields[3] as OrganizationMemberStatus
      ..role = fields[4] as OrganizationRoleType;
  }

  @override
  void write(BinaryWriter writer, MemberHive obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.avatarUrl)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
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
