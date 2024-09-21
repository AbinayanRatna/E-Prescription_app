import 'package:abin/colors.dart';
import 'package:abin/userlogmodel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class DocHospitalSelectPage extends StatefulWidget {
  const DocHospitalSelectPage({super.key});

  @override
  State<StatefulWidget> createState() => DocHospitalSelectPageState();
}

class DocHospitalSelectPageState extends State<DocHospitalSelectPage> {
  DatabaseReference dbRefHospital = FirebaseDatabase.instance.ref();
  var userDetailsBox = Hive.box<UserDetails>("User");
  String phoneNumber = "";
  late String uuid;
  String hopitalNowIn = "None of the hospitals";
  TextEditingController hospitalNameController = TextEditingController();

  @override
  void initState() {
    phoneNumber = userDetailsBox.getAt(0)!.user_phone;
    if(userDetailsBox.getAt(0)!.userHospitalNow=="new"){
      hopitalNowIn = "None of the hospitals";
    }else{
      hopitalNowIn = userDetailsBox.getAt(0)!.userHospitalNow!;
    }
    dbRefHospital = dbRefHospital.child("doctor/${phoneNumber}/hospitals");
    super.initState();
  }

  Widget listItem({required Map thisUserHospitals}) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.w),
      child: Container(
        decoration: BoxDecoration(
            color: Color.fromRGBO(229, 227, 221, 1.0),
            borderRadius: BorderRadius.circular(20.w)),
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
                              topLeft: Radius.circular(20.w),
                              bottomLeft: Radius.circular(20.w),
                              bottomRight: Radius.zero,
                              topRight: Radius.zero)),
                      elevation: (0),
                      padding: (EdgeInsets.only(top: 10.w, bottom: 10.w)),
                      backgroundColor: const Color.fromRGBO(5, 84, 97, 1.0)),
                  onPressed: () {},
                  child: Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 5.w, bottom: 5.w,right:5.w,left: 5.w),
                          child: Text(
                            thisUserHospitals['name'],
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
                                topRight: Radius.circular(20.w),
                                bottomRight: Radius.circular(20.w),
                                bottomLeft: Radius.zero,
                                topLeft: Radius.zero)),
                        elevation: (0),
                        padding: (EdgeInsets.only(top: 10.w, bottom: 10.w)),
                        backgroundColor:
                            const Color.fromRGBO(229, 227, 221, 1.0)),
                    onPressed: () {
                      setState(() {
                        hopitalNowIn=thisUserHospitals['name'];
                        UserDetails updatedUser = UserDetails(
                            user_phone: userDetailsBox.getAt(0)!.user_phone,
                            user_type: userDetailsBox.getAt(0)!.user_type,
                            user_logout: false,
                            userHospitalNow: thisUserHospitals['name']);
                        userDetailsBox.putAt(0, updatedUser);
                      });
                    },
                    child: Text(
                      "Select",
                      style: TextStyle(fontSize: 15.w, color: Colors.black),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        toolbarHeight: 60.w,
        title: Text(
          "Select hospital",
          style: TextStyle(
              fontSize: 20.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.only(top: 10.w, right: 10.w, left: 10.w),
                child: Container(
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(213, 233, 239, 1.0),
                      borderRadius: BorderRadius.circular(20.w)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 30.w, top: 20.w),
                        child: Text(
                          "Hospital name:",
                          style: TextStyle(
                              color: Color.fromRGBO(35, 35, 35, 1.0),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              top: 2.w, left: 30.w, right: 30.w),
                          child: TextField(
                            controller: hospitalNameController,
                            decoration: const InputDecoration(
                                hintStyle: TextStyle(
                                    color: Color.fromRGBO(104, 196, 209, 1.0)),
                                hintText: "eg:- Royal hospital colombo"),
                            style: (TextStyle(
                                color: Colors.indigo, fontSize: 15.w)),
                          )),
                      Padding(
                        padding:
                            EdgeInsets.only(top: 20.w, left: 30.w, right: 30.w),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.w))),
                          onPressed: () {
                            setState(() {
                              uuid = const Uuid().v4();
                            });
                            Map<String, String> doctorMapHospital = {
                              "name":
                                  hospitalNameController.text.trim().toString(),
                              "id": uuid,
                            };
                            dbRefHospital.child(uuid).set(doctorMapHospital);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(top: 8.w, bottom: 8.w),
                            child: Text(
                              "Add hospital",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex:1,
              child: Padding(
                padding: EdgeInsets.only(top: 20.w,left:15.w,right: 15.w),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.w),
                    color: Color.fromRGBO(222, 232, 232, 1.0),
                  ),
                  child: Padding(
                    padding:  EdgeInsets.only(left:10.w,right: 10.w),
                    child: Center(child: Text("$hopitalNowIn is selected",style: TextStyle(color: Colors.black,fontSize: 16.sp),)),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.only(top: 15.w),
                child: FirebaseAnimatedList(
                  defaultChild: Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      height: 35.w,
                      width: 35.w,
                      child: const CircularProgressIndicator(
                        backgroundColor: Color.fromRGBO(25, 56, 133, 1.0),
                        valueColor: AlwaysStoppedAnimation(Colors.lightBlue),
                        strokeWidth: 10,
                      ),
                    ),
                  ),
                  query: dbRefHospital,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    Map hospitals = snapshot.value as Map;
                    hospitals['key'] = snapshot.key;
                    return listItem(thisUserHospitals: hospitals);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
