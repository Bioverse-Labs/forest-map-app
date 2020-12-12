// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geopoint.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GeopointHiveAdapter extends TypeAdapter<GeopointHive> {
  @override
  final int typeId = 2;

  @override
  GeopointHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GeopointHive()
      ..lat = fields[0] as double
      ..lng = fields[1] as double;
  }

  @override
  void write(BinaryWriter writer, GeopointHive obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.lat)
      ..writeByte(1)
      ..write(obj.lng);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeopointHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
