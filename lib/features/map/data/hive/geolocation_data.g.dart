// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geolocation_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GeolocationDataHiveAdapter extends TypeAdapter<GeolocationDataHive> {
  @override
  final int typeId = 8;

  @override
  GeolocationDataHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GeolocationDataHive()
      ..name = fields[1] as String
      ..dataProperties =
          (fields[0] as List)?.cast<GeolocationDataPropertiesHive>();
  }

  @override
  void write(BinaryWriter writer, GeolocationDataHive obj) {
    writer
      ..writeByte(2)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(0)
      ..write(obj.dataProperties);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeolocationDataHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
