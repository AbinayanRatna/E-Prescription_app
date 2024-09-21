import 'package:abin/patientmodel.dart';
import 'package:abin/prescription_editing_page.dart';
import 'package:abin/userlogmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'colors.dart';

class SendPrescriptionPage extends StatefulWidget {
  final int patientIndex;

  const SendPrescriptionPage({super.key, required this.patientIndex});

  @override
  State<StatefulWidget> createState() => _SendPrescriptionPageState();
}

class _SendPrescriptionPageState extends State<SendPrescriptionPage> {
  var userBox = Hive.box<UserDetails>('User');
  var patientBox = Hive.box<Patient>('Patients');
  late Patient patient;
  late UserDetails userNow;
  String receiverPhoneNumber="";
  TextEditingController controller_phone = TextEditingController();
  TextEditingController controller_patientName = TextEditingController();

  @override
  void initState() {
    patient = patientBox.getAt(widget.patientIndex)!;
    userNow = userBox.getAt(0)!;
    super.initState();
  }

  @override
  void dispose() {
    controller_phone.dispose(); // Clean up the controller when the widget is disposed
    controller_patientName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        toolbarHeight: 60.w,
        title: Text(
          "Send Prescription",
          style: TextStyle(
              fontSize: 20.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 20.w, left: 15.w, right: 15.w),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 15.w),
                  child: TextField(
                    controller: controller_phone,
                    keyboardType: const TextInputType.numberWithOptions(),
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelStyle: TextStyle(fontSize: 16.sp),
                        hintText: "07********",
                        hintStyle: TextStyle(
                            fontSize: 14.sp, color: Colors.black38),
                        labelText:
                            "Receiver's mobile number (app registered)"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.w),
                  child: TextField(
                    controller: controller_patientName,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelStyle: TextStyle(fontSize: 16.sp),
                        labelText: "Receiver name"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.w,bottom: 10.w),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.w))),
                    onPressed: () {},
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 10.w, bottom: 10.w, left: 10.w, right: 10.w),
                      child: Text(
                        "Send",
                        style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(223, 225, 225, 1.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10.w, bottom: 15.w),
                        child: Center(
                            child: Text(
                          "Prescription preview",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.sp),
                        )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 10.w, right: 20.w, bottom: 15.w),
                        child: ValueListenableBuilder(
                        valueListenable: controller_phone,
                        builder: (context, TextEditingValue value, _) {
                          return Text(
                            "Date: ${patient.date}\nHospital: ${patient.hopital}\n"
                                "Patient name: ${patient.patient_name}\n"
                                "Receiver phone number: ${value.text.trim()}",
                            style: TextStyle(
                                fontSize: 15.sp,
                                color: const Color.fromRGBO(46, 46, 46, 1.0)),
                          );
                        },
                      ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 10.w, right: 20.w, bottom: 15.w),
                        child: Text(
                          "Diagnosis: ${patient.diagnosis}\n\n"
                          "Extra details: ${(patient.extra_details != "")?patient.extra_details:"N/A"}\n\nMedicines : ",
                          style: TextStyle(
                              fontSize: 15.sp,
                              color: const Color.fromRGBO(46, 46, 46, 1.0)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 5.w, right: 5.w, bottom: 5.w),
                        child: ValueListenableBuilder(
                          valueListenable: patientBox.listenable(),
                          builder: (context, Box<Patient> box, _) {
                            if (box.isEmpty) {
                              return const Center(child: Text("No patients found."));
                            }
                            if (patient.medicines.isEmpty) {
                              return Center(child: Text("No medicines found for this patient."));
                            }
                            return ListView.builder(shrinkWrap: true, // Fix for the height issue
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: patient.medicines.length,
                              itemBuilder: (context, index) {
                                Medicine medicine=patient.medicines[index];

                                return Card(
                                  margin: EdgeInsets.only(bottom:10.w,right:5.w,left:5.w),
                                  child: ListTile(
                                    title: Padding(
                                      padding:  EdgeInsets.only(bottom: 3.w),
                                      child: Text((medicine.medicineName)!="" ? medicine.medicineName.toUpperCase():"N/A",style: TextStyle(fontSize: 15.sp,color: Colors.black,fontWeight: FontWeight.bold),),
                                    ),
                                    subtitle: Text("Frequency: ${medicine.frequency}\n"
                                        "Dosage: ${medicine.dosage}\n"
                                        "Route: ${medicine.route}\n"
                                        "Duration: ${medicine.duration}\n"
                                        "Intake time: ${medicine.intakeTime}\n"
                                        "Refill times: ${medicine.refillTimes}\n"),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit),
                                          onPressed: () {
                                            // Remove the medicine from the patient's medicine list
                                            setState(() {
                                               // Update the patient in the box after modification
                                              Navigator.push(context, MaterialPageRoute(builder: (context)=>PrescriptionEditingPage(medIndex: index, patient: patient, medicine: medicine, patientIndex: widget.patientIndex)));
                                            });
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            // Remove the medicine from the patient's medicine list
                                            setState(() {
                                              patient.medicines.removeAt(index);
                                              patientBox.putAt(widget.patientIndex, patient); // Update the patient in the box after modification
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
