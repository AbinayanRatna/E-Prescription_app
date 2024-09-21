import 'package:abin/colors.dart';
import 'package:abin/patient_check.dart';
import 'package:abin/patientmodel.dart';
import 'package:abin/send_prescription.dart';
import 'package:abin/userlogmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';

class DiagnosisPage extends StatefulWidget {
  final List<Medicine> medicines_list;

  const DiagnosisPage({super.key, required this.medicines_list});

  @override
  State<StatefulWidget> createState() => DiagnosisPageState();
}

class DiagnosisPageState extends State<DiagnosisPage> {
  TextEditingController controller_extra_details = TextEditingController();
  TextEditingController controller_diagnosis_details = TextEditingController();
  TextEditingController controller_phoneNumber = TextEditingController();
  TextEditingController controller_patientName = TextEditingController();
  var userBox = Hive.box<UserDetails>('User');

  Future<void> addPatientToLocalDatabase(Patient patient, List<Medicine> medicines) async {
    var box = Hive.box<Patient>('Patients');
    var boxMedicine = Hive.box<Medicine>('Medicines');
    for(int i=0;i<medicines.length;i++){
      await boxMedicine.add(medicines.elementAt(i));
    }
    await box.add(patient);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        toolbarHeight: 60.w,
        title: Text(
          "Diagnosis info",
          style: TextStyle(fontSize: 20.sp, color: Colors.white,fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 25.w, right: 10.w, left: 10.w),
                  child: Column(
                    children: [
                      TextField(
                        controller: controller_diagnosis_details,
                        maxLines: 6,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: const OutlineInputBorder(),
                          hintText: "Describe about the diagnosis",
                          hintStyle: const TextStyle(color: Colors.black26),
                          labelStyle: TextStyle(fontSize: 16.sp),
                          label: const Text("Diagnosis details"),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15.w),
                        child: TextField(
                          maxLines: 6,
                          controller: controller_extra_details,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: const OutlineInputBorder(),
                            hintText: "Describe additional information",
                            hintStyle: const TextStyle(color: Colors.black26),
                            labelStyle: TextStyle(fontSize: 16.sp),
                            label: const Text("Additional info"),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15.w),
                        child: TextField(
                          controller: controller_phoneNumber,
                          keyboardType: const TextInputType.numberWithOptions(),
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelStyle: TextStyle(fontSize: 16.sp),
                              hintText: "07********",
                              hintStyle: TextStyle(
                                  fontSize: 14.sp, color: Colors.black38),
                              labelText:
                                  "Patient mobile number (app registered)"),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15.w),
                        child: TextField(
                          controller: controller_patientName,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelStyle: TextStyle(fontSize: 16.sp),
                              labelText: "Patient name"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.zero)),
                  backgroundColor: const Color.fromRGBO(67, 137, 147, 1.0),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ViewPatientsScreen()));
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 20.w, bottom: 20.w),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  // backgroundColor: const Color.fromRGBO(23, 64, 124, 1.0),
                  backgroundColor: const Color.fromRGBO(4, 62, 71, 1.0),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.zero)),
                ),
                onPressed: () async {
                  if (controller_diagnosis_details.text.trim().toString() ==
                      "") {
                    showAlertDialog(
                        context, "Diagnosis details must be provided.");
                  } else if (controller_patientName.text.trim().toString() ==
                          "" ||
                      controller_phoneNumber.text.trim().toString() == "") {
                    showAlertDialog(
                        context, "Patient details should be provided");
                  } else if (controller_phoneNumber.text
                          .trim()
                          .toString()
                          .length !=
                      10) {
                    showAlertDialog(context, "Incorrect phone number");
                  } else {
                    if(widget.medicines_list.isNotEmpty){
                      Patient patient = Patient(
                          patient_name:
                          controller_patientName.text.trim().toString(),
                          phone_number:
                          controller_phoneNumber.text.trim().toString(),
                          medicines: widget.medicines_list,
                          diagnosis:
                          controller_diagnosis_details.text.trim().toString(),
                          extra_details:
                          controller_extra_details.text.trim().toString(),
                          date: "12/12/2024",
                          hopital: userBox.getAt(0)!.userHospitalNow!
                      );
                      await addPatientToLocalDatabase(patient,widget.medicines_list);
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>SendPrescriptionPage()), (route)=>route.isFirst);
                    }else if(widget.medicines_list.isEmpty){
                      showAlertDialog(context, "Add medicines first");
                    }
                  }
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 20.w, bottom: 20.w),
                  child: Text(
                    "Next",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
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
showSuccessAlertDialog(BuildContext context) {
  // Create button
  Widget okButton = ElevatedButton(
    style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(13.w)))),
    child: Text("Got it",
        style: TextStyle(
            fontSize: 15.sp, color: Colors.blue, fontWeight: FontWeight.bold)),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    backgroundColor: Colors.blue,
    shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(5.w)),
    content: Text(
      "Patient added to local database",
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
