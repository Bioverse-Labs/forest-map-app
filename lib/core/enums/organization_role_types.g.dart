// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_role_types.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrganizationRoleTypeAdapter extends TypeAdapter<OrganizationRoleType> {
  @override
  final int typeId = 100;

  @override
  OrganizationRoleType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return OrganizationRoleType.member;
      case 1:
        return OrganizationRoleType.admin;
      case 2:
        return OrganizationRoleType.owner;
      default:
        return OrganizationRoleType.member;
    }
  }

  @override
  void write(BinaryWriter writer, OrganizationRoleType obj) {
    switch (obj) {
      case OrganizationRoleType.member:
        writer.writeByte(0);
        break;
      case OrganizationRoleType.admin:
        writer.writeByte(1);
        break;
      case OrganizationRoleType.owner:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrganizationRoleTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
