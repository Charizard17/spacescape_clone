// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spaceship_details.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SpaceshipTypeAdapter extends TypeAdapter<SpaceshipType> {
  @override
  final int typeId = 1;

  @override
  SpaceshipType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SpaceshipType.Phoenix;
      case 1:
        return SpaceshipType.Defcom;
      case 2:
        return SpaceshipType.Liberator;
      case 3:
        return SpaceshipType.Piranha;
      case 4:
        return SpaceshipType.Leonov;
      case 5:
        return SpaceshipType.Bigboy;
      case 6:
        return SpaceshipType.Vengeance;
      case 7:
        return SpaceshipType.Goliath;
      default:
        return SpaceshipType.Phoenix;
    }
  }

  @override
  void write(BinaryWriter writer, SpaceshipType obj) {
    switch (obj) {
      case SpaceshipType.Phoenix:
        writer.writeByte(0);
        break;
      case SpaceshipType.Defcom:
        writer.writeByte(1);
        break;
      case SpaceshipType.Liberator:
        writer.writeByte(2);
        break;
      case SpaceshipType.Piranha:
        writer.writeByte(3);
        break;
      case SpaceshipType.Leonov:
        writer.writeByte(4);
        break;
      case SpaceshipType.Bigboy:
        writer.writeByte(5);
        break;
      case SpaceshipType.Vengeance:
        writer.writeByte(6);
        break;
      case SpaceshipType.Goliath:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpaceshipTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
