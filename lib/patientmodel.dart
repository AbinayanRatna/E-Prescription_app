import 'package:hive/hive.dart';
part 'patientmodel.g.dart';


@HiveType(typeId:0)
class Patient extends HiveObject{
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

  Patient({required this.patient_name,required this.phone_number, required this.medicines, required this.diagnosis,required this.extra_details});
}

@HiveType(typeId:1)
class Medicine extends HiveObject {
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
