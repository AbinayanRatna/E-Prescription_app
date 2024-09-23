import 'dart:ui';

import 'package:abin/colors.dart';
import 'package:abin/doctor_hospitals.dart';
import 'package:abin/login_screen.dart';
import 'package:abin/patient_check.dart';
import 'package:abin/patientmodel.dart';
import 'package:abin/prescription_writing_page.dart';
import 'package:abin/userlogmodel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';

class DocHomescreen extends StatefulWidget {
  final String phoneNumber;

  const DocHomescreen({super.key, required this.phoneNumber});

  @override
  State<DocHomescreen> createState() => _DocHomescreenState();
}

class _DocHomescreenState extends State<DocHomescreen> {
  late CarouselSliderController controller;
  String hospitalName = "";
  var userBox = Hive.box<UserDetails>("User");
  var medicineBox = Hive.box<Medicine>("Medicines");
  String syncAvailable = "";
  String userNow="";
  late DatabaseReference dbRefSync;
   DatabaseReference dbRefMedicine=FirebaseDatabase.instance.ref().child("medicines");
  String medicineName ='Unknown';
  String brandName =  'Unknown';
  String dosage ='Not specified';
  String refill =  'Not specified';
  String frequency = 'Not specified';
  String route = 'Not specified';
  String intakeTime ='Not specified';
  String duration = 'Not specified';

  @override
  void initState() {
    userNow=userBox.getAt(0)!.user_phone;
    dbRefSync=FirebaseDatabase.instance.ref().child("doctor/$userNow/syncAvailable");
    controller = CarouselSliderController();
    hospitalName = userBox.getAt(0)!.userHospitalNow;
    syncUpdate();
    super.initState();
  }

  final List<Widget> imageAddress = [
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30.w)),
        color: Colors.purpleAccent,
      ),
      margin: EdgeInsets.only(left: 15.w),
      child: Center(
        child: Text("ad1", style: TextStyle(fontSize: 25.w)),
      ),
    ),
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30.w)),
        color: Colors.pinkAccent,
      ),
      margin: EdgeInsets.only(left: 15.w),
      child: Center(
        child: Text("ad2", style: TextStyle(fontSize: 25.w)),
      ),
    ),
    Container(
      margin: EdgeInsets.only(left: 15.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30.w)),
        color: Colors.pink,
      ),
      child: Center(
        child: Text("ad3", style: TextStyle(fontSize: 25.w)),
      ),
    ),
  ];

  Future<void> getPrescriptionFromFirebase() async {
    medicineBox.clear();
    DatabaseEvent medicineEvent = await dbRefMedicine.once();
    DataSnapshot medicineSnapshot = medicineEvent.snapshot;
    if (medicineSnapshot.value != null) {
        Map<dynamic, dynamic> medicines = medicineSnapshot.value as Map<dynamic, dynamic>;
        medicines.forEach((key, value) async {
          // Use null-aware operators to safely access the fields
          setState(()  {
            medicineName = value['medicine_name'] ?? 'Unknown';
            brandName = value['brand_name'] ?? 'Unknown';
            dosage = value['dosage'] ?? 'Not specified';
            refill = value['refill_time'] ?? 'Not specified';
            frequency = value['frequency'] ?? 'Not specified';
            route = value['route'] ?? 'Not specified';
            intakeTime = value['intake_time'] ?? 'Not specified';
            duration = value['duration'] ?? 'Not specified';

            Medicine medicineDet =Medicine(
                medicineName: medicineName,
                brandName: brandName,
                dosage: dosage,
                frequency: frequency,
                intakeTime: intakeTime,
                route: route,
                duration: duration,
                refillTimes: refill);
            medicineBox.add(medicineDet);
          });
        });

    }
    setState(() {
      syncAvailable='no';
    });

  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            message,
            style: const TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialogSync(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            message,
            style: const TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> syncUpdate() async {
    DatabaseEvent event = await dbRefSync.once();
    DataSnapshot snapshot = event.snapshot;
    if (snapshot.value != null) {
      setState(() {
        syncAvailable = snapshot.value.toString();
      });
    } else {
      _showErrorDialog(context, "Invalid error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return false to disable back button
        return false;
      },
      child: ScreenUtilInit(
        minTextAdapt: true,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                const Icon(
                  Icons.person, color: Color.fromRGBO(6, 83, 94, 1.0),),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: Text(
                      "Dr.${userBox.getAt(0)!.userName}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,),
                    ),
                  ),
                ),
              ],
            ),
            toolbarHeight: 60.w,
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 15.w, left: 10.w),
                child: InkWell(
                  onTap: () {
                    userBox.clear();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                          (route) => false,
                    );
                  },
                  child: Container(
                    width: 35.w,
                    height: 35.w,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(
                      Icons.logout,
                      // color: Color.fromRGBO(9, 75, 75, 1.0),
                      color: Color.fromRGBO(3, 152, 175, 1.0),
                    ),
                  ),
                ),
              ),
            ],
            backgroundColor: primaryColor,
          ),
          backgroundColor: const Color.fromRGBO(236, 230, 230, 1.0),
          body: Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery
                .of(context)
                .size
                .height,
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Opacity(
                      opacity: 0.2,
                      child: SvgPicture.asset(
                        "assets/opacimage.svg",
                      ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: EdgeInsets.only(top: 15.w),
                        child: Container(
                          child: Center(
                            child: CarouselSlider(
                              carouselController: controller,
                              items: imageAddress,
                              options: CarouselOptions(
                                  height: MediaQuery
                                      .of(context)
                                      .size
                                      .height /
                                      3.5.h,
                                  autoPlay: true,
                                  autoPlayInterval:
                                  Duration(milliseconds: 1800),
                                  autoPlayAnimationDuration:
                                  const Duration(milliseconds: 500)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 25.w, right: 25.w, bottom: 5.w, top: 20.w),
                        child: Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.w),
                            color: Color.fromRGBO(175, 221, 221, 1.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 10.w,
                                right: 10.w,
                                top: 10.w,
                                bottom: 5.w),
                            child: Center(
                                child: Text(
                                  "${hospitalName} is selected.\nDate = 12/12/2024",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.sp),
                                )),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(30.w, 10.w, 25.w, 0),
                          //color: Colors.blue,
                          //const Color.fromRGBO(33, 160, 164, 1.0),
                          height: MediaQuery
                              .of(context)
                              .size
                              .height -
                              (MediaQuery
                                  .of(context)
                                  .size
                                  .height / 1.6.w),
                          child: GridView(
                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio:
                                MediaQuery
                                    .of(context)
                                    .size
                                    .width < 700
                                    ? (1.1)
                                    : (1.5),
                                mainAxisSpacing: 20.w,
                                crossAxisSpacing: 20.w),
                            children: [
                              InkWell(
                                onTap: () {
                                  if (hospitalName != "No hospital") {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const PrescriptionWritingPage()));
                                  } else {
                                    _showErrorDialog(context,
                                        "Please select a hospital to continue");
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topRight,
                                        end: Alignment.bottomLeft,
                                        stops: [
                                          0.1.w,
                                          0.4.w,
                                          0.6.w,
                                          0.9.w,
                                        ],
                                        colors: const [
                                          Color.fromRGBO(3, 152, 175, 1.0),
                                          Color.fromRGBO(119, 200, 216, 1.0),
                                          Color.fromRGBO(119, 200, 216, 1.0),
                                          Color.fromRGBO(2, 121, 138, 1.0),
                                        ],
                                      ),
                                      //  color: Color.fromRGBO(188, 197, 197, 1.0),
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20.w),
                                          topLeft: Radius.circular(20.w),
                                          bottomRight: Radius.circular(20.w),
                                          bottomLeft: Radius.circular(20.w))),
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Column(
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(
                                              top: 20.w, bottom: 10.w),
                                          child: Icon(Icons.edit_calendar_sharp,color: Colors.white,size: 55.w,)),
                                      Center(
                                          child: Text(
                                            "Prescribe",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.sp,
                                                color: Colors.white),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  if(syncAvailable=="yes"){
                                      await getPrescriptionFromFirebase().then((onValue){
                                          Map<String,String> syncUpdate={
                                            "syncAvailable":"no"
                                          };
                                          DatabaseReference dbRefSyncUpdate=FirebaseDatabase.instance.ref().child("doctor/$userNow");
                                          dbRefSyncUpdate.update(syncUpdate);

                                      });

                                  }else{
                                    _showErrorDialogSync(context, "App is already up-to-date");
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topRight,
                                        end: Alignment.bottomLeft,
                                        stops: [
                                          0.1.w,
                                          0.4.w,
                                          0.6.w,
                                          0.9.w,
                                        ],
                                        colors: const [
                                          Color.fromRGBO(3, 152, 175, 1.0),
                                          Color.fromRGBO(119, 200, 216, 1.0),
                                          Color.fromRGBO(119, 200, 216, 1.0),
                                          Color.fromRGBO(2, 121, 138, 1.0),
                                        ],
                                      ),
                                      //color: Color.fromRGBO(188, 197, 197, 1.0),
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20.w),
                                          topLeft: Radius.circular(20.w),
                                          bottomRight: Radius.circular(20.w),
                                          bottomLeft: Radius.circular(20.w))),
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 20.w, bottom: 10.w),
                                        child: Icon(syncAvailable=="no"?Icons.check_circle:Icons.sync,color: Colors.white,size: 55.w,),),
                                      Center(
                                          child: Text(
                                            syncAvailable == "no"
                                                ? "Up-to-date"
                                                : "Sync now",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.sp,
                                              color: Colors.white,
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {

                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewPatientsScreen()));


                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      // color: Color.fromRGBO(188, 197, 197, 1.0),
                                        gradient: LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomLeft,
                                          stops: [
                                            0.1.w,
                                            0.4.w,
                                            0.6.w,
                                            0.9.w,
                                          ],
                                          colors: const [
                                            Color.fromRGBO(3, 152, 175, 1.0),
                                            Color.fromRGBO(119, 200, 216, 1.0),
                                            Color.fromRGBO(119, 200, 216, 1.0),
                                            Color.fromRGBO(2, 121, 138, 1.0),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(20.w),
                                            topLeft: Radius.circular(20.w),
                                            bottomRight: Radius.circular(20.w),
                                            bottomLeft: Radius.circular(20.w))),
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 20.w, bottom: 10.w),
                                          child: Icon(Icons.history_sharp,color: Colors.white,size: 55.w,)
                                        ),
                                        Center(
                                            child: Text(
                                              "History",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.sp,
                                                color: Colors.white,
                                              ),
                                            )),
                                      ],
                                    )),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                      const DocHospitalSelectPage(),
                                    ),
                                  ).then((_) =>
                                      setState(() {
                                        hospitalName =
                                        userBox.getAt(0)!.userHospitalNow!;
                                      }));
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomLeft,
                                          stops: [
                                            0.1.w,
                                            0.4.w,
                                            0.6.w,
                                            0.9.w,
                                          ],
                                          colors: const [
                                            Color.fromRGBO(3, 152, 175, 1.0),
                                            Color.fromRGBO(119, 200, 216, 1.0),
                                            Color.fromRGBO(119, 200, 216, 1.0),
                                            Color.fromRGBO(2, 121, 138, 1.0),
                                          ],
                                        ),
                                        //color: Color.fromRGBO(188, 197, 197, 1.0),
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(20.w),
                                            topLeft: Radius.circular(20.w),
                                            bottomRight: Radius.circular(20.w),
                                            bottomLeft: Radius.circular(20.w))),
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 20.w, bottom: 10.w),
                                          child: Icon(Icons.local_hospital,color:Colors.white,size: 55.w,)
                                        ),
                                        Center(
                                            child: Text(
                                              "Hospitals",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.sp,
                                                color: Colors.white,
                                              ),
                                            )),
                                      ],
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 20.w),
                        child: const Align(
                          alignment: Alignment.bottomCenter,
                          child: Text("Copyrights reserved"),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
