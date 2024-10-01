// Importing the hive package to use its data storage features
import 'package:hive/hive.dart';

//Part directive that links the generated code file for hive adapters.
part 'patientmodel.g.dart';

/// Defining a hive type for the "patient" class with a typeId of 0.
@HiveType(typeId: 0)
class Patient extends HiveObject {
  //Definig the fields to store the details.
  @HiveField(0)
  String patient_name;

  @HiveField(1)
  String phone_number;

  @HiveField(2)
  String diagnosis;

  @HiveField(3)
  String extra_details;

  @HiveField(4)
  List<Medicine> medicines;

  @HiveField(5)
  String hopital;

  @HiveField(6)
  String date;

  ///Initialize all fields of the "Patient" class.
  Patient(
      {required this.patient_name,
      required this.phone_number,
      required this.medicines,
      required this.diagnosis,
      required this.extra_details,
      required this.date,
      required this.hopital});
}

/// Define a hive type for the "Medicine" class which allows to store instances of the classes.
@HiveType(typeId: 1)
class Medicine extends HiveObject {
  // Definig the fields for medicine.
  @HiveField(0)
  String medicineName;

  @HiveField(1)
  String brandName;

  @HiveField(2)
  String dosage;

  @HiveField(3)
  String frequency;

  @HiveField(4)
  String intakeTime;

  @HiveField(5)
  String route;

  @HiveField(6)
  String duration;

  @HiveField(7)
  String refillTimes;

///constructor to initialize all fields of the "Medicine" class.
  Medicine({
    required this.medicineName,
    required this.brandName,
    required this.dosage,
    required this.frequency,
    required this.intakeTime,
    required this.route,
    required this.duration,
    required this.refillTimes,
  });
}
