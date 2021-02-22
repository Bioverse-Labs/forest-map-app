// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geolocation_data_properties.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GeolocationDataPropertiesHiveAdapter
    extends TypeAdapter<GeolocationDataPropertiesHive> {
  @override
  final int typeId = 9;

  @override
  GeolocationDataPropertiesHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GeolocationDataPropertiesHive()
      ..id = fields[0] as String
      ..type = fields[1] as String
      ..specie = fields[2] as String
      ..detDate = fields[3] as DateTime
      ..imageDate = fields[4] as DateTime
      ..polygon = fields[5] as PolygonHive;
  }

  @override
  void write(BinaryWriter writer, GeolocationDataPropertiesHive obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.specie)
      ..writeByte(3)
      ..write(obj.detDate)
      ..writeByte(4)
      ..write(obj.imageDate)
      ..writeByte(5)
      ..write(obj.polygon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeolocationDataPropertiesHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
