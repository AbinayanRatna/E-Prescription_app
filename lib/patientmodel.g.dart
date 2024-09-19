// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patientmodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PatientAdapter extends TypeAdapter<Patient> {
  @override
  final int typeId = 0;

  @override
  Patient read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Patient(
      patient_name: fields[0] as String,
      phone_number: fields[1] as String,
      medicines: (fields[4] as List).cast<Medicine>(),
      diagnosis: fields[2] as String,
      extra_details: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Patient obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.patient_name)
      ..writeByte(1)
      ..write(obj.phone_number)
      ..writeByte(2)
      ..write(obj.diagnosis)
      ..writeByte(3)
      ..write(obj.extra_details)
      ..writeByte(4)
      ..write(obj.medicines);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PatientAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MedicineAdapter extends TypeAdapter<Medicine> {
  @override
  final int typeId = 1;

  @override
  Medicine read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Medicine(
      medicineName: fields[0] as String,
      brandName: fields[1] as String,
      dosage: fields[2] as String,
      frequency: fields[3] as String,
      intakeTime: fields[4] as String,
      route: fields[5] as String,
      duration: fields[6] as String,
      refillTimes: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Medicine obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.medicineName)
      ..writeByte(1)
      ..write(obj.brandName)
      ..writeByte(2)
      ..write(obj.dosage)
      ..writeByte(3)
      ..write(obj.frequency)
      ..writeByte(4)
      ..write(obj.intakeTime)
      ..writeByte(5)
      ..write(obj.route)
      ..writeByte(6)
      ..write(obj.duration)
      ..writeByte(7)
      ..write(obj.refillTimes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicineAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
