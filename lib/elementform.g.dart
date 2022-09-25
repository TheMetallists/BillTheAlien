// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'elementform.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ToiletpaperAdapter extends TypeAdapter<Toiletpaper> {
  @override
  final int typeId = 1;

  @override
  Toiletpaper read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Toiletpaper(
      uuid: fields[0] as String,
      num_serial: fields[1] as String,
      num_number: fields[2] as int,
      billValue: fields[3] as BillValue,
      date_inserted: fields[4] as String,
      state: fields[5] as BillState,
    );
  }

  @override
  void write(BinaryWriter writer, Toiletpaper obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.uuid)
      ..writeByte(1)
      ..write(obj.num_serial)
      ..writeByte(2)
      ..write(obj.num_number)
      ..writeByte(3)
      ..write(obj.billValue)
      ..writeByte(4)
      ..write(obj.date_inserted)
      ..writeByte(5)
      ..write(obj.state);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ToiletpaperAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BillValueAdapter extends TypeAdapter<BillValue> {
  @override
  final int typeId = 2;

  @override
  BillValue read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BillValue.r10;
      case 1:
        return BillValue.r50;
      case 2:
        return BillValue.r100;
      case 3:
        return BillValue.r200;
      case 4:
        return BillValue.r500;
      case 5:
        return BillValue.r1000;
      case 6:
        return BillValue.r2000;
      case 7:
        return BillValue.r5000;
      default:
        return BillValue.r10;
    }
  }

  @override
  void write(BinaryWriter writer, BillValue obj) {
    switch (obj) {
      case BillValue.r10:
        writer.writeByte(0);
        break;
      case BillValue.r50:
        writer.writeByte(1);
        break;
      case BillValue.r100:
        writer.writeByte(2);
        break;
      case BillValue.r200:
        writer.writeByte(3);
        break;
      case BillValue.r500:
        writer.writeByte(4);
        break;
      case BillValue.r1000:
        writer.writeByte(5);
        break;
      case BillValue.r2000:
        writer.writeByte(6);
        break;
      case BillValue.r5000:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BillValueAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BillStateAdapter extends TypeAdapter<BillState> {
  @override
  final int typeId = 3;

  @override
  BillState read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BillState.posessment;
      case 1:
        return BillState.possesmentMoved;
      case 2:
        return BillState.paidWith;
      default:
        return BillState.posessment;
    }
  }

  @override
  void write(BinaryWriter writer, BillState obj) {
    switch (obj) {
      case BillState.posessment:
        writer.writeByte(0);
        break;
      case BillState.possesmentMoved:
        writer.writeByte(1);
        break;
      case BillState.paidWith:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BillStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
