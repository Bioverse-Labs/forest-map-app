// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geolocation_file.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GeolocationFileHiveAdapter extends TypeAdapter<GeolocationFileHive> {
  @override
  final int typeId = 10;

  @override
  GeolocationFileHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GeolocationFileHive()
      ..id = fields[1] as String?
      ..fileName = fields[2] as String?
      ..downloadDate = fields[3] as DateTime?;
  }

  @override
  void write(BinaryWriter writer, GeolocationFileHive obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.fileName)
      ..writeByte(3)
      ..write(obj.downloadDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeolocationFileHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
