// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tree.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TreeHiveAdapter extends TypeAdapter<TreeHive> {
  @override
  final int typeId = 1;

  @override
  TreeHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TreeHive()
      ..name = fields[0] as String
      ..imagePath = fields[1] as String
      ..location = fields[2] as GeopointHive;
  }

  @override
  void write(BinaryWriter writer, TreeHive obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.imagePath)
      ..writeByte(2)
      ..write(obj.location);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TreeHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
