import 'package:abin/alert_dialog_dosage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'alert_dialog_duration.dart';

class PrescriptionWritingPage extends StatefulWidget {
  const PrescriptionWritingPage({super.key});

  @override
  State<StatefulWidget> createState() => PrescriptionWritingPageState();
}

class PrescriptionWritingPageState extends State<PrescriptionWritingPage> {
  List<DropdownMenuItem<String>> get dropdownItems_frequency {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "q3H", child: Text("Every 3 hours")),
      const DropdownMenuItem(value: "q4H", child: Text("Every 4 hours")),
      const DropdownMenuItem(value: "q6H", child: Text("Every 6 hours")),
      const DropdownMenuItem(value: "q8H", child: Text("Every 8 hours")),
      const DropdownMenuItem(value: "q12H", child: Text("Every 12 hours")),
      const DropdownMenuItem(value: "q24H", child: Text("Every 24 hours")),
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

  List<DropdownMenuItem<String>> get dropdownItems_intaketime {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(
          value: "Before meals", child: Text("Before meals")),
      const DropdownMenuItem(value: "After meals", child: Text("After meals")),
      const DropdownMenuItem(
          value: "before/after", child: Text("Before/After")),
    ];
    return menuItems;
  }

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

  String selectedValue_frequency = "q8H";
  String selectedValue_intaketime = "Before meals";
  String selectedValue_route = "Taken by mouth";
  String selectedValue_duration = "q12H";
  String selectedValue_refill = "no refill";

  String text_dosage = "500 mg";
  String text_duration = "3 days";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        toolbarHeight: 60.w,
        title: Text(
          "Select medicine",
          style: TextStyle(fontSize: 22.sp, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Expanded(
              flex: 10,
              child: Padding(
                padding: EdgeInsets.only(top: 25.w, right: 10.w, left: 10.w),
                child: Column(
                  children: [
                    const TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Medicine Name (generic)"),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15.w),
                      child: const TextField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Brand name (If available)"),
                      ),
                    ),
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
                                  side: BorderSide(color: Colors.black45),
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
                                  side: BorderSide(color: Colors.black45),
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
            ),
          ],
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
                  backgroundColor: const Color.fromRGBO(78, 131, 218, 1.0),
                ),
                onPressed: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=>const FirstPage()));
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 20.w, bottom: 20.w),
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white, fontSize: 20.sp,fontWeight: FontWeight.bold),
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
                  backgroundColor: Color.fromRGBO(8, 43, 69, 1.0),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.zero)),
                ),
                onPressed: () {},
                child: Padding(
                  padding: EdgeInsets.only(top: 20.w, bottom: 20.w),
                  child: Text(
                    "Next",
                    style: TextStyle(color: Colors.white, fontSize: 20.sp,fontWeight: FontWeight.bold),
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
          return AlertDialogPrescription_dosage();
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
          return AlertDialogPrescription_duration();
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
