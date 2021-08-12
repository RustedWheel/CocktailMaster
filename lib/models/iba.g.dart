// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iba.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IBAAdapter extends TypeAdapter<IBA> {
  @override
  final int typeId = 3;

  @override
  IBA read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return IBA.unforgettables;
      case 1:
        return IBA.contemporaryClassics;
      case 2:
        return IBA.newEraDrinks;
      default:
        return IBA.unforgettables;
    }
  }

  @override
  void write(BinaryWriter writer, IBA obj) {
    switch (obj) {
      case IBA.unforgettables:
        writer.writeByte(0);
        break;
      case IBA.contemporaryClassics:
        writer.writeByte(1);
        break;
      case IBA.newEraDrinks:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IBAAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
