// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userlogmodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserDetailsAdapter extends TypeAdapter<UserDetails> {
  @override
  final int typeId = 2;

  @override
  UserDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserDetails(
      user_phone: fields[0] as String,
      user_type: fields[1] as String,
      user_logout: fields[2] as bool,
      userHospitalNow: fields[3] as String,
      userName: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserDetails obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.user_phone)
      ..writeByte(1)
      ..write(obj.user_type)
      ..writeByte(2)
      ..write(obj.user_logout)
      ..writeByte(3)
      ..write(obj.userHospitalNow)
      ..writeByte(4)
      ..write(obj.userName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
