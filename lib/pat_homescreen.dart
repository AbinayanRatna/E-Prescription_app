import 'package:abin/colors.dart';
import 'package:abin/patient_prescription_read.dart';
import 'package:abin/userlogmodel.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'login_screen.dart';

class PatHomeScreen extends StatefulWidget {
  final String phoneNumber;

  const PatHomeScreen({super.key, required this.phoneNumber});

  @override
  State<PatHomeScreen> createState() => _PatHomeScreenState();
}

class _PatHomeScreenState extends State<PatHomeScreen> {
  // form state
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var userBox = Hive.box<UserDetails>("User");
  late CarouselSliderController controller;
  late DatabaseReference dbRefPatient;

  @override
  void initState() {
    dbRefPatient = FirebaseDatabase.instance
        .ref()
        .child("patient/${userBox.getAt(0)!.user_phone}/prescriptions");
    controller = CarouselSliderController();
    super.initState();
  }

  Widget listItem({required Map thisUserPrescriptions}) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.w),
      child: Container(
        decoration: BoxDecoration(
            color: Color.fromRGBO(229, 227, 221, 1.0),
            borderRadius: BorderRadius.circular(10.w)),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.w),
                            bottomLeft: Radius.circular(10.w),
                            bottomRight: Radius.zero,
                            topRight: Radius.zero)),
                    elevation: (0),
                    padding: (EdgeInsets.only(top: 10.w, bottom: 10.w)),
                    backgroundColor: const Color.fromRGBO(3, 125, 147, 1.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PatientPrescriptionRead(
                          userId: thisUserPrescriptions["id"],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: 5.w, bottom: 5.w, right: 5.w, left: 5.w),
                          child: Text(
                            "${thisUserPrescriptions['hospital']}\nDate:${thisUserPrescriptions['date']}",
                            style:
                                TextStyle(fontSize: 16.sp, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10.w),
                                bottomRight: Radius.circular(10.w),
                                bottomLeft: Radius.zero,
                                topLeft: Radius.zero)),
                        elevation: (0),
                        padding: (EdgeInsets.only(top: 10.w, bottom: 10.w)),
                        backgroundColor:
                            const Color.fromRGBO(229, 227, 221, 1.0)),
                    onPressed: () {
                      dbRefPatient.child(thisUserPrescriptions["id"]).remove();
                    },
                    child: Text(
                      "Remove",
                      style: TextStyle(fontSize: 15.w, color: Colors.black),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height; // full screen height
    double width = MediaQuery.of(context).size.width; // full screen width
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Icon(
              Icons.person,
              color: Color.fromRGBO(6, 83, 94, 1.0),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: Text(
                  userBox.getAt(0)!.userName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
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
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              child: Opacity(
                  opacity: 0.2,
                  child: SvgPicture.asset(
                    "assets/opacimage.svg",
                  )),
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
                              height:
                                  MediaQuery.of(context).size.height / 3.5.h,
                              autoPlay: true,
                              autoPlayInterval: Duration(milliseconds: 1800),
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 500)),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 10.w, left: 20.w, bottom: 10.w),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Prescriptions",
                        style: TextStyle(
                            color: const Color.fromRGBO(7, 123, 143, 1.0),
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    child: FirebaseAnimatedList(
                      defaultChild: Align(
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          height: 35.w,
                          width: 35.w,
                          child: const CircularProgressIndicator(
                            backgroundColor: Color.fromRGBO(25, 56, 133, 1.0),
                            valueColor:
                                AlwaysStoppedAnimation(Colors.lightBlue),
                            strokeWidth: 10,
                          ),
                        ),
                      ),
                      query: dbRefPatient,
                      itemBuilder: (BuildContext context, DataSnapshot snapshot,
                          Animation<double> animation, int index) {
                        Map prescriptions = snapshot.value as Map;
                        prescriptions['key'] = snapshot.key;
                        return listItem(thisUserPrescriptions: prescriptions);
                      },
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
    );
  }
}
