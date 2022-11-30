// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocationHiveAdapter extends TypeAdapter<LocationHive> {
  @override
  final int typeId = 4;

  @override
  LocationHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocationHive()
      ..id = fields[0] as String
      ..lat = fields[1] as double
      ..lng = fields[2] as double
      ..timestamp = fields[3] as DateTime
      ..altitude = fields[4] as double
      ..accuracy = fields[5] as double
      ..heading = fields[6] as double
      ..floor = fields[7] as int
      ..speed = fields[8] as double
      ..speedAccuracy = fields[9] as double;
  }

  @override
  void write(BinaryWriter writer, LocationHive obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.lat)
      ..writeByte(2)
      ..write(obj.lng)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.altitude)
      ..writeByte(5)
      ..write(obj.accuracy)
      ..writeByte(6)
      ..write(obj.heading)
      ..writeByte(7)
      ..write(obj.floor)
      ..writeByte(8)
      ..write(obj.speed)
      ..writeByte(9)
      ..write(obj.speedAccuracy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
