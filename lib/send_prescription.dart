import 'package:abin/Signinpage.dart';
import 'package:abin/userlogmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';

import 'colors.dart';

class SendPrescriptionPage extends StatefulWidget {
  const SendPrescriptionPage({super.key});

  @override
  State<StatefulWidget> createState() => _SendPrescriptionPageState();
}

class _SendPrescriptionPageState extends State<SendPrescriptionPage> {
  var userBox = Hive.box<UserDetails>('User');
  TextEditingController controller_phone = TextEditingController();
  TextEditingController controller_patientName = TextEditingController();

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
          height: MediaQuery.of(context).size.height,
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
                      labelText: "Patient mobile number (app registered)"),
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
              Padding(
                padding: EdgeInsets.only(top: 15.w),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.w))
                  ),
                  onPressed: () {},
                  child: Padding(
                    padding: EdgeInsets.only(top:10.w,bottom: 10.w,left:10.w,right: 10.w),
                    child: Text("Send",style: TextStyle(fontSize: 20.sp,color: Colors.white,fontWeight: FontWeight.bold),),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
