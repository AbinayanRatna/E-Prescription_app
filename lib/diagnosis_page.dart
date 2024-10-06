import 'package:abin/colors.dart'; 
import 'package:abin/patient_check.dart'; 
import 'package:abin/patientmodel.dart'; 
import 'package:abin/send_prescription.dart'; 
import 'package:abin/userlogmodel.dart'; 
import 'package:flutter/material.dart'; 
import 'package:flutter_screenutil/flutter_screenutil.dart'; 
import 'package:hive/hive.dart'; 

// DiagnosisPage widget, which is a StatefulWidget
class DiagnosisPage extends StatefulWidget {
  final List<Medicine> medicines_list; // List of medicines passed as a parameter

  // Constructor for DiagnosisPage
  const DiagnosisPage({super.key, required this.medicines_list});

  @override
  State<StatefulWidget> createState() => DiagnosisPageState(); // Creates the state for this widget
}

// State class for DiagnosisPage
class DiagnosisPageState extends State<DiagnosisPage> {
  // Controllers for TextFields to manage user input
  TextEditingController controller_extra_details = TextEditingController();
  TextEditingController controller_diagnosis_details = TextEditingController();
  TextEditingController controller_phoneNumber = TextEditingController();
  TextEditingController controller_patientName = TextEditingController();
  
  // Boxes for accessing local storage with Hive
  var userBox = Hive.box<UserDetails>('User'); // Box for user details
  var box = Hive.box<Patient>('Patients'); // Box for patients

  // Function to add a patient to the local database
  Future<void> addPatientToLocalDatabase(Patient patient) async {
    await box.add(patient); // Adding the patient to the Hive box
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true, // Shows back button automatically
        toolbarHeight: 60.w, // Sets the height of the app bar
        title: Text(
          "Diagnosis info", // Title of the page
          style: TextStyle(fontSize: 20.sp, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor, // Background color of the app bar
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width, // Sets the width to screen width
        height: MediaQuery.of(context).size.height, // Sets the height to screen height
        child: SingleChildScrollView( // Allows scrolling
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 25.w, right: 10.w, left: 10.w), // Padding around the column
                  child: Column(
                    children: [
                      // TextField for diagnosis details
                      TextField(
                        controller: controller_diagnosis_details,
                        maxLines: 6,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always, // Keeps label always visible
                          border: const OutlineInputBorder(), // Outline border for the text field
                          hintText: "Describe about the diagnosis", // Hint text when empty
                          hintStyle: const TextStyle(color: Colors.black26), // Style for hint text
                          labelStyle: TextStyle(fontSize: 16.sp), // Style for label text
                          label: const Text("Diagnosis details *"), // Label for the text field
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15.w), // Padding above the next text field
                        child: TextField(
                          maxLines: 6,
                          controller: controller_extra_details,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: const OutlineInputBorder(),
                            hintText: "Describe additional information",
                            hintStyle: const TextStyle(color: Colors.black26),
                            labelStyle: TextStyle(fontSize: 16.sp),
                            label: const Text("Additional info"), // Label for additional info
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15.w),
                        child: TextField(
                          controller: controller_phoneNumber,
                          keyboardType: const TextInputType.numberWithOptions(), // Numeric input for phone number
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelStyle: TextStyle(fontSize: 16.sp),
                              hintText: "07********", // Hint for phone number format
                              hintStyle: TextStyle(
                                  fontSize: 14.sp, color: Colors.black38),
                              labelText:
                                  "Patient mobile number (app registered)"), // Label for phone number
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15.w),
                        child: TextField(
                          controller: controller_patientName,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelStyle: TextStyle(fontSize: 16.sp),
                              labelText: "Patient name"), // Label for patient name
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
                  elevation: 0, // No elevation for button
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.zero)), // Square corners
                  backgroundColor: const Color.fromRGBO(67, 137, 147, 1.0), // Background color for cancel button
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ViewPatientsScreen())); // Navigate to ViewPatientsScreen
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 20.w, bottom: 20.w),
                  child: Text(
                    "Cancel", // Text for cancel button
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
                  backgroundColor: const Color.fromRGBO(4, 62, 71, 1.0), // Background color for next button
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.zero)),
                ),
                onPressed: () async {
                  // Validations before proceeding to the next step
                  if (controller_diagnosis_details.text.trim().toString() == "") {
                    showAlertDialog(context, "Diagnosis details must be provided."); // Show alert if diagnosis is missing
                  } else if (controller_patientName.text.trim().toString() == "" ||
                      controller_phoneNumber.text.trim().toString() == "") {
                    showAlertDialog(context, "Patient details should be provided"); // Show alert if patient details are missing
                  } else if (controller_phoneNumber.text
                          .trim()
                          .toString()
                          .length !=
                      10) {
                    showAlertDialog(context, "Incorrect phone number"); // Show alert for incorrect phone number
                  } else {
                    // Proceed if medicines are added
                    if (widget.medicines_list.isNotEmpty) {
                      Patient patient = Patient(
                          patient_name: controller_patientName.text.trim().toString(),
                          phone_number: controller_phoneNumber.text.trim().toString(),
                          medicines: widget.medicines_list, // List of medicines
                          diagnosis: controller_diagnosis_details.text.trim().toString(),
                          extra_details: controller_extra_details.text.trim().toString(),
                          date: "12/12/2024", // Placeholder for date
                          hopital: userBox.getAt(0)!.userHospitalNow!); // Get hospital information

                      int oldIndex = 0; // Variable to store index for the patient
                      if (box.isNotEmpty) {
                        oldIndex = box.length; // Get current length of the box
                        print("old index aeae inside: $oldIndex");
                      }
                      print("old index aeae outside: $oldIndex");
                      await addPatientToLocalDatabase(patient); // Add patient to local database
                      // Navigate to SendPrescriptionPage and remove the current page from the stack
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SendPrescriptionPage(patientIndex: oldIndex)), (route) => route.isFirst);
                    } else if (widget.medicines_list.isEmpty) {
                      showAlertDialog(context, "Add medicines first"); // Show alert if no medicines added
                    }
                  }
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 20.w, bottom: 20.w),
                  child: Text(
                    "Next", // Text for next button
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

// Function to show alert dialog with a message
showAlertDialog(BuildContext context, String detail) {
  // Create button
  Widget okButton = ElevatedButton(
    style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        side: const BorderSide(width: 1, color: Colors.blue)),
    child: const Text("Ok", style: TextStyle(color: Colors.blue)),
    onPressed: () {
      Navigator.of(context).pop(); // Close the dialog
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Alert!"), // Title of the alert
    content: Text(detail), // Content of the alert
    actions: [
      okButton, // Add the ok button to the alert
    ],
  );

  // Show dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert; // Return the alert dialog
    },
  );
}
