// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_member_status.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrganizationMemberStatusAdapter
    extends TypeAdapter<OrganizationMemberStatus> {
  @override
  final int typeId = 101;

  @override
  OrganizationMemberStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return OrganizationMemberStatus.removed;
      case 1:
        return OrganizationMemberStatus.disabled;
      case 2:
        return OrganizationMemberStatus.pending;
      case 3:
        return OrganizationMemberStatus.active;
      default:
        return OrganizationMemberStatus.removed;
    }
  }

  @override
  void write(BinaryWriter writer, OrganizationMemberStatus obj) {
    switch (obj) {
      case OrganizationMemberStatus.removed:
        writer.writeByte(0);
        break;
      case OrganizationMemberStatus.disabled:
        writer.writeByte(1);
        break;
      case OrganizationMemberStatus.pending:
        writer.writeByte(2);
        break;
      case OrganizationMemberStatus.active:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrganizationMemberStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
