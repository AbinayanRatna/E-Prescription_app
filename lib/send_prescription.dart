import 'package:abin/doc_homescreen.dart';
import 'package:abin/patientmodel.dart';
import 'package:abin/prescription_editing_page.dart';
import 'package:abin/userlogmodel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import 'colors.dart';

class SendPrescriptionPage extends StatefulWidget {
  final int patientIndex;

  const SendPrescriptionPage({super.key, required this.patientIndex});

  @override
  State<StatefulWidget> createState() => _SendPrescriptionPageState();
}

class _SendPrescriptionPageState extends State<SendPrescriptionPage> {
  late DatabaseReference dbRefPatient;
  late DatabaseReference dbRefDoctor;
  late DatabaseReference dbRefMedicine;
  var userBox = Hive.box<UserDetails>('User');
  var patientBox = Hive.box<Patient>('Patients');
  late Patient patient;
  late UserDetails userNow;
  String receiverPhoneNumber = "";
  TextEditingController controller_phone = TextEditingController();
  TextEditingController controller_patientName = TextEditingController();
  List<Map<dynamic, dynamic>> searchResults = [];
  bool isLoading = false;
  List<String> patientNumbers=[];

  @override
  void initState() {
    patient = patientBox.getAt(widget.patientIndex)!;
    userNow = userBox.getAt(0)!;
    dbRefPatient = FirebaseDatabase.instance.ref().child("patient");
    dbRefDoctor = FirebaseDatabase.instance.ref().child("doctor");
    dbRefMedicine = FirebaseDatabase.instance.ref().child("medicines");
    super.initState();
  }

  void searchInFirebase(String query) async {
    setState(() {
      isLoading = true; // Show loading indicator
      searchResults.clear(); // Clear previous results
    });

    try {
      // Fetch data from Firebase
      DatabaseEvent event = await dbRefPatient.once();
      DataSnapshot snapshotTaken = event.snapshot;

      // Check if there's data to process
      if (snapshotTaken.value != null) {
        Map<dynamic, dynamic> data =
            Map<dynamic, dynamic>.from(snapshotTaken.value as Map);

        // Filter results based on query
        List<Map<dynamic, dynamic>> tempResults = [];
        data.forEach((key, value) {
          if (value['phoneNumber'] != null &&
              value['phoneNumber'].toString().contains(query)) {
            tempResults.add(value);
          }
        });

        // Update search results
        setState(() {
          searchResults = tempResults;
        });
      }
    } catch (e) {
      // Handle potential errors
      print('Error fetching data: $e');
    } finally {
      // Hide loading indicator
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    controller_phone
        .dispose(); // Clean up the controller when the widget is disposed
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
                        hintStyle:
                            TextStyle(fontSize: 14.sp, color: Colors.black38),
                        labelText: "Search the phone number"),
                    onChanged: (query) {
                      if (query.isNotEmpty) {
                        searchInFirebase(query);
                      } else {
                        setState(() {
                          searchResults.clear();
                        });
                      }
                    },
                  ),
                ),
                if (isLoading) const CircularProgressIndicator(),
                controller_phone.text.isNotEmpty && searchResults.isNotEmpty
                    ? ListView.builder(
                  shrinkWrap: true,
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          final patient = searchResults[index];
                          return ListTile(
                            tileColor: Color.fromRGBO(225, 223, 223, 1.0),
                            title: Text(patient['phoneNumber']),
                            onTap: (){
                              setState(() {
                                controller_phone.text=patient['phoneNumber'];
                                controller_patientName.text=patient['name'];
                                patientNumbers.add(patient['phoneNumber']);
                                searchResults.clear();
                              });
                            },
                          );
                        },
                      )
                    : Container(),
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
                  padding: EdgeInsets.only(top: 15.w, bottom: 10.w),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.w))),
                    onPressed: () async{

                      String uuid=const Uuid().v4();
                      if(patientNumbers.contains(controller_phone.text)){
                        Map<String,String> prescription={
                          "id":uuid,
                          "date":patient.date,
                          "hospital":patient.hopital,
                          "doctor":userNow.userName,
                          "patient_name":patient.patient_name,
                          "patient_phone":patient.phone_number,
                          "receiver_phone_number":controller_phone.text,
                          "diagnosis":patient.diagnosis,
                          "extra_details":patient.extra_details,
                        };
                        await dbRefPatient.child("${controller_phone.text}/prescriptions/$uuid").set(prescription);
                        await dbRefDoctor.child("${userNow.user_phone}/prescriptions/$uuid").set(prescription);
                        Map<String,String> medicinedInPrescription={};
                        for(int i=0;i<patient.medicines.length;i++){
                          medicinedInPrescription={
                            "medicine_name":patient.medicines[i].medicineName,
                            "brand_name":patient.medicines[i].brandName,
                            "frequency":patient.medicines[i].frequency,
                            "dosage":patient.medicines[i].dosage,
                            "route":patient.medicines[i].route,
                            "duration":patient.medicines[i].duration,
                            "intake_time":patient.medicines[i].intakeTime,
                            "refill_time":patient.medicines[i].refillTimes,
                          };
                          await dbRefPatient.child("${controller_phone.text}/prescriptions/$uuid/medicines").push().set(medicinedInPrescription);
                          print("done done 1");
                          await dbRefDoctor.child("${userNow.user_phone}/prescriptions/$uuid/medicines").push().set(medicinedInPrescription);
                          print("done done 2");
                          await dbRefMedicine.push().set(medicinedInPrescription);
                          print("done done 3");
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>DocHomescreen(phoneNumber: userNow.user_phone)));
                        }
                      }else{
                        showAlertDialog(context, "This mobile numbers is not registered in app!");
                        controller_phone.text="";
                        controller_patientName.text="";
                      }


                    },
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
                              "Doctor name: ${userNow.userName}\n"
                              "Patient name: ${patient.patient_name}\n"
                              "Patient phone: ${patient.phone_number}\n"
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
                          "Extra details: ${(patient.extra_details != "") ? patient.extra_details : "N/A"}\n\nMedicines : ",
                          style: TextStyle(
                              fontSize: 15.sp,
                              color: const Color.fromRGBO(46, 46, 46, 1.0)),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 5.w, right: 5.w, bottom: 5.w),
                        child: ValueListenableBuilder(
                          valueListenable: patientBox.listenable(),
                          builder: (context, Box<Patient> box, _) {
                            if (box.isEmpty) {
                              return const Center(
                                  child: Text("No patients found."));
                            }
                            if (patient.medicines.isEmpty) {
                              return Center(
                                  child: Text(
                                      "No medicines found for this patient."));
                            }
                            return ListView.builder(
                              shrinkWrap: true, // Fix for the height issue
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: patient.medicines.length,
                              itemBuilder: (context, index) {
                                Medicine medicine = patient.medicines[index];

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
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PrescriptionEditingPage(
                                                              medIndex: index,
                                                              patient: patient,
                                                              medicine:
                                                                  medicine,
                                                              patientIndex: widget
                                                                  .patientIndex)));
                                            });
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            // Remove the medicine from the patient's medicine list
                                            setState(() {
                                              patient.medicines.removeAt(index);
                                              patientBox.putAt(
                                                  widget.patientIndex,
                                                  patient); // Update the patient in the box after modification
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

showAlertDialog(BuildContext context, String detail) {
  // Create button
  Widget okButton = ElevatedButton(
    style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(13.w)))),
    child: Text("Got it",
        style: TextStyle(
            fontSize: 15.sp, color: Colors.red, fontWeight: FontWeight.bold)),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    backgroundColor: Colors.red,
    shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(5.w)),
    content: Text(
      detail,
      style: TextStyle(
          fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.white),
    ),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
