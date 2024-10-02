import 'dart:typed_data';
import 'dart:ui';  // Provides image manipulation and rendering capabilities.
import 'package:abin/patientmodel.dart';
import 'package:abin/userlogmodel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart'; // used to save images to the gallery.
import 'colors.dart';


class PatientPrescriptionRead extends StatefulWidget {
  final String userId;      // Holds the userID to fetch the relevant prescription.

  const PatientPrescriptionRead({super.key, required this.userId});

  @override
  State<StatefulWidget> createState() => _PatientPrescriptionReadState();
}

class _PatientPrescriptionReadState extends State<PatientPrescriptionRead> {
  var userBox = Hive.box<UserDetails>("User"); // Access hive box to retrive user details.
  late DatabaseReference dbRefUser;
  // Various fields for stroing prescrption details.
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
  String doctorName = "";
  String patientPhone = "";
  String patient_name = "";
  List<Medicine> medicineList = [];
  GlobalKey _globalKey = GlobalKey();
  Color myColor = Color(0xDFDDDDDD); // Your widget color


  @override
  void initState() {
    //Initializes th e state and sets up Firebase database reference for the user's prescription.
    print("aeaeaeae : " + widget.userId);
    dbRefUser = FirebaseDatabase.instance.ref().child(
        "patient/${userBox.getAt(0)!.user_phone}/prescriptions/${widget.userId}");
    getPrescriptionFromFirebase();
    super.initState();
  }

  /// 
  Future<void> _saveToGallery() async {
    // Capture the widget as an image
    RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    if (boundary != null) {
      final image = await boundary.toImage(pixelRatio: 3.0); // ccapture image with a high resolution.
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List(); // Ensure to use the nullable operator here
      print("Original Color aeaeae: ${myColor.toString()}");
      // Save the image to the gallery
      final result = await ImageGallerySaver.saveImage(pngBytes);
      print('Image saved to gallery: $result');
    }
  }
  
/// function to fetch prescription details and medicine list from Firebase.
  Future<void> getPrescriptionFromFirebase() async {
    DatabaseEvent accountEvent = await dbRefUser.once();
    DataSnapshot accountSnapshot = accountEvent.snapshot;
    if (accountSnapshot.value != null) {
      Map<dynamic, dynamic> prescriptionDetails =
          accountSnapshot.value as Map<dynamic, dynamic>;
      setState(() {
        // set prescription details from firebase.
        patient_name = prescriptionDetails['patient_name'];
        hospital = prescriptionDetails['hospital'];
        doctorName = prescriptionDetails['doctor'];
        patientPhone = prescriptionDetails['patient_phone'];
        extra_details = prescriptionDetails['extra_details'];
        diagnosis = prescriptionDetails['diagnosis'];
        date = prescriptionDetails['date'];
      });
      
      // fetch medicine data
      DatabaseEvent accountEventMed = await dbRefUser.child("medicines").once();
      DataSnapshot accountSnapshotMed = accountEventMed.snapshot;

      if (accountSnapshotMed.value != null) {
        Map<dynamic, dynamic> medicines =
            accountSnapshotMed.value as Map<dynamic, dynamic>;

        medicines.forEach((key, value) async {
          // Use null-aware operators to safely access the fields
          setState(() {
            medicineName = value['medicine_name'] ?? 'Unknown';
            brandName = value['brand_name'] ?? 'Unknown';
            dosage = value['dosage'] ?? 'Not specified';
            refill = value['refill_time'] ?? 'Not specified';
            frequency = value['frequency'] ?? 'Not specified';
            route = value['route'] ?? 'Not specified';
            intakeTime = value['intake_time'] ?? 'Not specified';
            duration = value['duration'] ?? 'Not specified';
            medicineList.add(Medicine(
                medicineName: medicineName,
                brandName: brandName,
                dosage: dosage,
                frequency: frequency,
                intakeTime: intakeTime,
                route: route,
                duration: duration,
                refillTimes: refill));
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15.w, left: 10.w),
            child: InkWell(
              onTap: () async {
                await _saveToGallery(); // Save the prescription to the gallery when tapped.
              },
              child: Container(
                width: 35.w,
                height: 35.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: const Icon(
                  Icons.arrow_circle_down,
                  // color: Color.fromRGBO(9, 75, 75, 1.0),
                  color: Color.fromRGBO(3, 152, 175, 1.0),
                ),
              ),
            ),
          ),
        ],
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
      body: RepaintBoundary(
        key: _globalKey,             // Key for capturing the widget image.
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: Color(0xDFDFDBDB),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10.w, right: 20.w, bottom: 15.w),
                child: Padding(
                  padding: EdgeInsets.only(top: 10.w),
                  child: Text(
                    "Date: $date\nHospital: $hospital\n"
                    "Doctor name: $doctorName\n"
                    "Patient name: $patient_name\n"
                    "Patient phone: $patientPhone\n",
                    style: TextStyle(
                        fontSize: 15.sp,
                        color:  Colors.black),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.w, right: 20.w, bottom: 15.w),
                child: Text(
                  "Diagnosis: $diagnosis\n\n"
                  "Extra details: ${(extra_details != "") ? extra_details : "N/A"}\n\nMedicines : ",
                  style: TextStyle(
                      fontSize: 15.sp,
                      color: Colors.black),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5.w, right: 5.w, bottom: 5.w),
                child: ListView.builder(
                  shrinkWrap: true, // Fix for the height issue
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: medicineList.length,
                  itemBuilder: (context, index) {
                    Medicine medicine = medicineList[index];
                    return Card(
                      margin:
                          EdgeInsets.only(bottom: 10.w, right: 10.w, left: 10.w),
                      child: ListTile(
                        title: Padding(
                          padding: EdgeInsets.only(bottom: 3.w),
                          child: Text(
                            (medicine.medicineName) != ""
                                ? medicine.medicineName.toUpperCase()
                                : "N/A",
                            style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        subtitle: Text("Frequency: ${medicine.frequency}\n"
                            "Dosage: ${medicine.dosage}\n"
                            "Route: ${medicine.route}\n"
                            "Duration: ${medicine.duration}\n"
                            "Intake time: ${medicine.intakeTime}\n"
                            "Refill times: ${medicine.refillTimes}\n"),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
