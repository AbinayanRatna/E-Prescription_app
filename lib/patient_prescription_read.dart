import 'package:abin/patientmodel.dart';
import 'package:abin/userlogmodel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';

import 'colors.dart';

class PatientPrescriptionRead extends StatefulWidget{
  final String userId;
  const PatientPrescriptionRead({super.key, required this.userId});

  @override
  State<StatefulWidget> createState() => _PatientPrescriptionReadState();

}

class _PatientPrescriptionReadState extends State<PatientPrescriptionRead> {
  var userBox = Hive.box<UserDetails>("User");
  late DatabaseReference dbRefUser;
  String medicineName = "";
  String brandName = "";
  String frequency = "";
  String duration = "";
  String route = "";
  String refill = "";
  String intakeTime = "";
  String dosage = "";
  String date = "";
  String diagnosis = "";
  String extra_details = "";
  String hospital = "";
  String patient_name = "";
  List<Medicine> medicineList=[];

  @override
  void initState() {
    print("aeaeaeae : "+widget.userId);
    dbRefUser = FirebaseDatabase.instance.ref().child(
        "patient/${userBox.getAt(0)!.user_phone}/prescriptions/${widget
            .userId}");
    getPrescriptionFromFirebase();
    super.initState();
  }

  Future<void> getPrescriptionFromFirebase() async {
    DatabaseEvent accountEvent = await dbRefUser.once();
    DataSnapshot accountSnapshot = accountEvent.snapshot;
    if (accountSnapshot.value != null) {
      Map<dynamic, dynamic> prescriptionDetails = accountSnapshot.value as Map<
          dynamic,
          dynamic>;
      patient_name = prescriptionDetails['patient_name'];
      print("aeaeaeae  aeaename: "+prescriptionDetails['patient_name']);
      hospital = prescriptionDetails['hospital'];
      extra_details = prescriptionDetails['extra_details'];
      diagnosis = prescriptionDetails['diagnosis'];
      date = prescriptionDetails['date'];

      DatabaseEvent accountEventMed = await dbRefUser.child("medicines").once();
      DataSnapshot accountSnapshotMed = accountEventMed.snapshot;

      if (accountSnapshotMed.value != null) {
        Map<dynamic, dynamic> medicines = accountSnapshotMed.value as Map<dynamic, dynamic>;

        medicines.forEach((key, value) async {
          // Use null-aware operators to safely access the fields
          medicineName = value['medicine_name'] ?? 'Unknown';
           brandName = value['brand_name'] ?? 'Unknown';
           dosage = value['dosage'] ?? 'Not specified';
           refill = value['refill_time'] ?? 'Not specified';
           frequency = value['frequency'] ?? 'Not specified';
           route = value['route'] ?? 'Not specified';
           intakeTime = value['intake_time'] ?? 'Not specified';
           duration = value['duration'] ?? 'Not specified';


        });
      }
    }
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          toolbarHeight: 60.w,
          title: Text(
            "Prescription preview",
            style: TextStyle(
                fontSize: 20.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: primaryColor,
        ),
        body: Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(223, 225, 225, 1.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: 10.w, right: 20.w, bottom: 15.w),

                  child: Text(
                    "Date: $date\nHospital: $hospital\n"
                        "Patient name: $patient_name\n",
                    style: TextStyle(
                        fontSize: 15.sp,
                        color: const Color.fromRGBO(46, 46, 46, 1.0)),
                  ),
                ),

              Padding(
                padding: EdgeInsets.only(
                    left: 10.w, right: 20.w, bottom: 15.w),
                child: Text(
                  "Diagnosis: $diagnosis\n\n"
                      "Extra details: ${(extra_details != "") ? extra_details : "N/A"}\n\nMedicines : ",
                  style: TextStyle(
                      fontSize: 15.sp,
                      color: const Color.fromRGBO(46, 46, 46, 1.0)),
                ),
              ),
              Padding(
                padding:
                EdgeInsets.only(left: 5.w, right: 5.w, bottom: 5.w),
                child: ListView.builder(
                      shrinkWrap: true, // Fix for the height issue
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: medicineList.length,
                      itemBuilder: (context, index) {
                        Medicine medicine = medicineList[index];

                        return Card(
                          margin: EdgeInsets.only(
                              bottom: 10.w, right: 5.w, left: 5.w),
                          child: ListTile(
                            title: Padding(
                              padding: EdgeInsets.only(bottom: 3.w),
                              child: Text(
                                (medicine.medicineName) != ""
                                    ? medicine.medicineName
                                    .toUpperCase()
                                    : "N/A",
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            subtitle: Text(
                                "Frequency: ${medicine.frequency}\n"
                                    "Dosage: ${medicine.dosage}\n"
                                    "Route: ${medicine.route}\n"
                                    "Duration: ${medicine.duration}\n"
                                    "Intake time: ${medicine.intakeTime}\n"
                                    "Refill times: ${medicine.refillTimes}\n"
                             ),
                          ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }
  }