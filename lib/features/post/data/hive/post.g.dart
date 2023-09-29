// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PostHiveAdapter extends TypeAdapter<PostHive> {
  @override
  final int typeId = 5;

  @override
  PostHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PostHive()
      ..id = fields[0] as String?
      ..userId = fields[1] as String?
      ..organizationId = fields[2] as String?
      ..specie = fields[3] as String?
      ..imageUrl = fields[4] as String?
      ..timestamp = fields[5] as DateTime?
      ..location = fields[6] as LocationHive?
      ..categoryId = fields[7] as int?
      ..dbh = fields[8] as int?
      ..landUse = fields[9] as String?;
  }

  @override
  void write(BinaryWriter writer, PostHive obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.organizationId)
      ..writeByte(3)
      ..write(obj.specie)
      ..writeByte(4)
      ..write(obj.imageUrl)
      ..writeByte(5)
      ..write(obj.timestamp)
      ..writeByte(6)
      ..write(obj.location)
      ..writeByte(7)
      ..write(obj.categoryId)
      ..writeByte(8)
      ..write(obj.dbh)
      ..writeByte(9)
      ..write(obj.landUse);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
