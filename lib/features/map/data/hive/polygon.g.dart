// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'polygon.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PolygonHiveAdapter extends TypeAdapter<PolygonHive> {
  @override
  final int typeId = 10;

  @override
  PolygonHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PolygonHive()
      ..id = fields[0] as String
      ..points = (fields[1] as List)?.cast<LatLngHive>();
  }

  @override
  void write(BinaryWriter writer, PolygonHive obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.points);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PolygonHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
