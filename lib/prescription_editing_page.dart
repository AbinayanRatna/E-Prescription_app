import 'package:abin/alert_dialog_dosage.dart';
import 'package:abin/colors.dart';
import 'package:abin/patientmodel.dart';
import 'package:abin/send_prescription.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Importing duration alert dialog widget
import 'alert_dialog_duration.dart';

/// PrescrptionEditing page
class PrescriptionEditingPage extends StatefulWidget {
  final int medIndex;   // medicine being edited
  final int patientIndex; // patient index in the list
  final Patient patient; 
  final Medicine medicine; // medicine that is being edited
  const PrescriptionEditingPage({super.key, required this.medIndex,required this.patient, required this.medicine, required this.patientIndex});

  @override
  State<StatefulWidget> createState() => PrescriptionWritingPageState();
}

/// Prescription Writing page : Manages the state of the Prescription Editing page
class PrescriptionWritingPageState extends State<PrescriptionEditingPage> {
  late TextEditingController controller_generic_name ;
  late TextEditingController controller_brand_name ;
  
  // list to hold the patient's medicine
  late List<Medicine> medicines_list ;

  // Variables for dropdown selection and text inputs
  String selectedValue_frequency = "Every 3 hours";
  String selectedValue_intaketime = "Before meals";
  String selectedValue_route = "Taken by mouth";
  String selectedValue_refill = "no refill";
  String text_dosage = "500 mg";
  String text_duration = "3 days";


  @override
  void initState() {
    // Initialize TextEditingControllers with current medicine details
    controller_generic_name = TextEditingController(text: widget.medicine.medicineName.toString());
    controller_brand_name = TextEditingController(text: widget.medicine.brandName.toString());
    //Initialize the list of medicines for the patient and dropdown selections
    medicines_list=widget.patient.medicines;
    selectedValue_frequency = widget.medicine.frequency;
    selectedValue_intaketime =  widget.medicine.intakeTime;
    selectedValue_route =  widget.medicine.route;
    selectedValue_refill =  widget.medicine.refillTimes;
    text_dosage =  widget.medicine.dosage;
    text_duration =  widget.medicine.duration;
    super.initState();
  }

  ///Function to add edited medicine back to the list
  Future<void> addMedicine(
      String genericName,
      String brandName,
      String frequency,
      String intakeTime,
      String route,
      String dosage,
      String duration,
      String refill) async {
    Medicine medicine = Medicine(
        medicineName: genericName,
        brandName: brandName,
        dosage: dosage,
        frequency: frequency,
        intakeTime: intakeTime,
        route: route,
        duration: duration,
        refillTimes: refill);
    medicines_list.add(medicine);
    medicines_list.removeAt(widget.medIndex);
  }

  /// Dropdown items for selecting the frequency of medication 
  List<DropdownMenuItem<String>> get dropdownItems_frequency {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(
          value: "Every 3 hours", child: Text("Every 3 hours")),
      const DropdownMenuItem(
          value: "Every 4 hours", child: Text("Every 4 hours")),
      const DropdownMenuItem(
          value: "Every 6 hours", child: Text("Every 6 hours")),
      const DropdownMenuItem(
          value: "Every 8 hours", child: Text("Every 8 hours")),
      const DropdownMenuItem(
          value: "Every 12 hours", child: Text("Every 12 hours")),
      const DropdownMenuItem(
          value: "Every 24 hours", child: Text("Every 24 hours")),
      const DropdownMenuItem(value: "0900, 2100", child: Text("0900, 2100")),
      const DropdownMenuItem(
          value: "0900, 1400, 2100", child: Text("0900, 1400, 2100")),
      const DropdownMenuItem(
          value: "0800, 1200, 1700", child: Text("0800, 1200, 1700")),
      const DropdownMenuItem(
          value: "0900, 1300, 1700, 2100",
          child: Text("0900, 1300, 1700, 2100")),
      const DropdownMenuItem(
          value: "0800, 1200, 1700, 2100",
          child: Text("0800, 1200, 1700, 2100")),
      const DropdownMenuItem(
          value: "0500, 0900, 1300, 1700, 2100",
          child: Text("0500, 0900, 1300, 1700, 2100")),
    ];
    return menuItems;
  }

  // dropdown items for selecting intake time
  List<DropdownMenuItem<String>> get dropdownItems_intaketime {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(
          value: "Before meals", child: Text("Before meals")),
      const DropdownMenuItem(value: "After meals", child: Text("After meals")),
      const DropdownMenuItem(
          value: "Before/After", child: Text("Before/After")),
    ];
    return menuItems;
  }

  // Dropdown items for selecting route of adminstration
  List<DropdownMenuItem<String>> get dropdownItems_routes {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "Taken by mouth", child: Text("Oral")),
      const DropdownMenuItem(
          value: "Injected directly into a vein", child: Text("Intravenous")),
      const DropdownMenuItem(
          value: "Injected into a muscle", child: Text("Intramuscular")),
      const DropdownMenuItem(
          value: "Injected under the skin", child: Text("Subcutaneous")),
      const DropdownMenuItem(
          value: "Applied to the skin", child: Text("Topical")),
      const DropdownMenuItem(value: "Breathed in", child: Text("Inhalation")),
      const DropdownMenuItem(
          value: "Administered via the rectum", child: Text("Rectal")),
      const DropdownMenuItem(
          value: "Placed under the tongue", child: Text("Sublingual")),
      const DropdownMenuItem(
          value: "Delivered across the skin", child: Text("Trans-dermal")),
    ];
    return menuItems;
  }

  // Dropdown items for selecting refill options
  List<DropdownMenuItem<String>> get dropdownItems_refill {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "no refill", child: Text("0")),
      const DropdownMenuItem(value: "1 refill", child: Text("1")),
      const DropdownMenuItem(value: "2 refill", child: Text("2")),
      const DropdownMenuItem(value: "3 refill", child: Text("3")),
      const DropdownMenuItem(value: "4 refill", child: Text("4")),
      const DropdownMenuItem(value: "5 refill", child: Text("5")),
      const DropdownMenuItem(value: "6 refill", child: Text("6")),
      const DropdownMenuItem(value: "7 refill", child: Text("7")),
    ];
    return menuItems;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        toolbarHeight: 60.w,
        title: Text(
          "Select medicine",
          style: TextStyle(fontSize: 20.sp, color: Colors.white),
        ),
        backgroundColor: primaryColor,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 25.w, right: 10.w, left: 10.w),
                child: Column(
                  children: [
                    TextField(
                      controller: controller_generic_name,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Medicine Name (generic)"),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15.w),
                      child: TextField(
                        controller: controller_brand_name,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Brand name (If available)"),
                      ),
                    ),
                    // Dropdown for selecting medicine frequency
                    Padding(
                        padding: EdgeInsets.only(top: 25.w, left: 5.w),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                "Frequency   : ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black45, width: 1.0),
                                  borderRadius: BorderRadius.circular(5.w),
                                ),
                                child: DropdownButton<String>(
                                  value: selectedValue_frequency,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedValue_frequency = newValue!;
                                    });
                                  },
                                  items: dropdownItems_frequency,
                                  isExpanded: true,
                                  underline:
                                      const SizedBox(), // Hide the default underline
                                ),
                              ),
                            ),
                          ],
                        )),
                    // Dropdown for selecting intake time
                    Padding(
                        padding: EdgeInsets.only(top: 25.w, left: 5.w),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                "Intake time : ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black45, width: 1.0),
                                  borderRadius: BorderRadius.circular(5.w),
                                ),
                                child: DropdownButton<String>(
                                  value: selectedValue_intaketime,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedValue_intaketime = newValue!;
                                    });
                                  },
                                  items: dropdownItems_intaketime,
                                  isExpanded: true,
                                  underline:
                                      const SizedBox(), // Hide the default underline
                                ),
                              ),
                            ),
                          ],
                        )),
                    // Dropdown for selecting route of administration
                    Padding(
                        padding: EdgeInsets.only(top: 25.w, left: 5.w),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                "Route way   : ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black45, width: 1.0),
                                  borderRadius: BorderRadius.circular(5.w),
                                ),
                                child: DropdownButton<String>(
                                  value: selectedValue_route,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedValue_route = newValue!;
                                    });
                                  },
                                  items: dropdownItems_routes,
                                  isExpanded: true,
                                  underline:
                                      const SizedBox(), // Hide the default underline
                                ),
                              ),
                            ),
                          ],
                        )),
                    Padding(
                      padding: EdgeInsets.only(top: 25.w, left: 5.w),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              "Strength      : ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: TextButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(color: Colors.black45),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.w),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                showAlertDialogFunction_dosage();
                              },
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 7.w),
                                  child: Text(
                                    text_dosage,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15.sp),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 25.w, left: 5.w),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              "Duration      : ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: TextButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(color: Colors.black45),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.w),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                showAlertDialogFunction_duration();
                              },
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 7.w),
                                  child: Text(
                                    text_duration,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15.sp),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 25.w, left: 5.w),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              "Refill times : ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black45, width: 1.0),
                                borderRadius: BorderRadius.circular(5.w),
                              ),
                              child: DropdownButton<String>(
                                value: selectedValue_refill,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedValue_refill = newValue!;
                                  });
                                },
                                items: dropdownItems_refill,
                                isExpanded: true,
                                underline:
                                    const SizedBox(), // Hide the default underline
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=>const FirstPage()));
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
                  if (controller_generic_name.text.trim().toString() == "" &&
                      controller_brand_name.text.trim().toString() == "") {
                    showAlertDialog(context);
                  } else {
                    await addMedicine(
                        controller_generic_name.text.trim().toString(),
                        controller_brand_name.text.trim().toString(),
                        selectedValue_frequency,
                        selectedValue_intaketime,
                        selectedValue_route,
                        text_dosage,
                        text_duration,
                        selectedValue_refill);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SendPrescriptionPage(patientIndex: widget.patientIndex)
                      ),
                    );
                  }
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 20.w, bottom: 20.w),
                  child: Text(
                    "Save",
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

  void showAlertDialogFunction_dosage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return const AlertDialogPrescription_dosage();
        }));
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          text_dosage = value;
        });
      }
    });
  }

  void showAlertDialogFunction_duration() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return const AlertDialogPrescription_duration();
        }));
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          text_duration = value;
        });
      }
    });
  }
}

showAlertDialog(BuildContext context) {
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
      "Medicine name or brand name should be filled.",
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
