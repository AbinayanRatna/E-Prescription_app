import 'dart:ui';

import 'package:abin/colors.dart';
import 'package:abin/doctor_hospitals.dart';
import 'package:abin/login_screen.dart';
import 'package:abin/prescription_writing_page.dart';
import 'package:abin/userlogmodel.dart';
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
  int currentIndex = 0;
  String hospitalName = "";
  var userBox = Hive.box<UserDetails>("User");

  //String hospitalNowIn="";

  @override
  void initState() {
    controller = CarouselSliderController();
    hospitalName = userBox.getAt(0)!.userHospitalNow!;
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
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: const Color(0xff764abc)),
                  accountName: Text(
                    "Person Name",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  accountEmail: Text(
                    "person1@gmail.com",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  currentAccountPicture: FlutterLogo(),
                ),
                ListTile(
                  leading: Icon(
                    Icons.home,
                  ),
                  title: const Text('Page 1'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.person,
                  ),
                  title: const Text('Page 2'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          appBar: AppBar(
            //automaticallyImplyLeading: false,
            title: Text(
              "Welcome doctor",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold),
            ),
            toolbarHeight:60.w,
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 15.w),
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
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
            ],
            backgroundColor: primaryColor,
          ),
          backgroundColor: const Color.fromRGBO(236, 230, 230, 1.0),
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
                                  height: MediaQuery.of(context).size.height /
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
                          width: MediaQuery.of(context).size.width,
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
                          height: MediaQuery.of(context).size.height -
                              (MediaQuery.of(context).size.height / 1.6.w),
                          child: GridView(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio:
                                        MediaQuery.of(context).size.width < 700
                                            ? (1.1)
                                            : (1.5),
                                    mainAxisSpacing: 20.w,
                                    crossAxisSpacing: 20.w),
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const PrescriptionWritingPage()));
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
                                          child: SvgPicture.asset(
                                            "assets/loginimage.svg",
                                            color: Colors.white,
                                            height: 45.w,
                                          )),
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
                                onTap: () {
                                  print("hospitalname eeeaaa : " +
                                      userBox.getAt(0)!.userHospitalNow!);
                                  /*
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>page()));

                                     */
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
                                          child: SvgPicture.asset(
                                            "assets/loginimage.svg",
                                            color: Colors.white,
                                            height: 45.w,
                                          )),
                                      Center(
                                          child: Text(
                                        "Settings",
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
                                  /*
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>page()));

                                     */
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
                                          child: SvgPicture.asset(
                                            "assets/loginimage.svg",
                                            color: Colors.white,
                                            height: 45.w,
                                          ),
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
                                  ).then((_) => setState(() {
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
                                          child: SvgPicture.asset(
                                            "assets/loginimage.svg",
                                            color: Colors.white,
                                            height: 45.w,
                                          ),
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
