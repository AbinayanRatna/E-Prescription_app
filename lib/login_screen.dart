import 'package:abin/Doc_homescreen.dart';
import 'package:abin/Pat_homescreen.dart';
import 'package:abin/Signinpage.dart';
import 'package:abin/colors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // form state
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? _phoneNumber;
  String? _password;

  Future<void> signIn(BuildContext context,String userType) async {
    DatabaseReference dbref=FirebaseDatabase.instance.ref().child("${userType}/${_phoneNumber}");
    DatabaseEvent accountEvent=await dbref.once();
    DataSnapshot accountSnapshot=accountEvent.snapshot;
    if(accountSnapshot.value != null){
      DatabaseEvent passwordEvent=await dbref.child("password").once();
      DataSnapshot passwordSnapshot=passwordEvent.snapshot;
      if(_password == passwordSnapshot.value){
        if(userType=="doctor"){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>DocHomeScreen()));
        }else if(userType=="patient"){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>PatHomeScreen()));
        }
      }else{
        _showErrorDialog(context, "Incorrect Password");
      }
    }else{
      _showErrorDialog(context, "Please create an account first");
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Log In Error',
            style: TextStyle(color: Colors.black),
          ),
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width; // full screen width
    return Scaffold(
      backgroundColor: const Color(0xFFF1EEEE),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Form(
              key: formKey,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 60.w),
                      child: SvgPicture.asset(
                        "assets/loginimage.svg",
                        height: width / 1.5,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 25.w),
                      child: RichText(
                        text: TextSpan(
                            text: "Login ",
                            style: TextStyle(
                                fontSize: 35.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                text: "Account ",
                                style: TextStyle(
                                    fontSize: 35.sp,
                                    color: Color.fromRGBO(7, 197, 227, 1.0),
                                    fontWeight: FontWeight.bold),
                              )
                            ]),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: 25.w, left: 25.w, right: 25.w),
                      child: TextFormField(
                        onSaved: (value) {
                          _phoneNumber = value;
                        },
                        validator: (number) {
                          if (number == null || number.isEmpty) {
                            return "Please Enter the Phone Number";
                          } else if (number.length != 10) {
                            return "Not a valid Phone Number";
                          } else if (!RegExp(r'^[0-9]+$').hasMatch(number)) {
                            return "Not a valid Phone Number";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.black12),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.w))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromRGBO(7, 40, 64, 1.0)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.w))),
                          prefixIcon:
                              const Icon(Icons.phone, color: Colors.black38),
                          labelText: "PHONE NUMBER",
                          filled: true,
                          fillColor: Colors.white,
                          labelStyle: TextStyle(
                              color: Colors.black45,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: 15.w, left: 25.w, right: 25.w),
                      child: TextFormField(
                        onSaved: (value) {
                          _password = value;
                        },
                        validator: (password) {
                          if (password == null || password.isEmpty) {
                            return "Please Enter the Password";
                          } else if (password.length < 6) {
                            return "Not a valid Password";
                          }
                          return null;
                        },
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.black12),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.w))),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromRGBO(7, 40, 64, 1.0)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.w))),
                            prefixIcon:
                                const Icon(Icons.lock, color: Colors.black38),
                            labelText: "PASSWORD",
                            filled: true,
                            fillColor: Colors.white,
                            labelStyle: TextStyle(
                                color: Colors.black45,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top:25.w,left: 35.w,right: 35.w),
                      child: Row(
                        children: [
                          Expanded(
                            flex:1,
                            child: Padding(
                              padding: EdgeInsets.only(right: 10.w),
                              child: Container(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    // Background color
                                    shadowColor: Colors.grey,
                                    // Shadow color
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.w)),
                                  ),
                                  onPressed: () {
                                    if (formKey.currentState?.validate() ??
                                        false) {
                                      formKey.currentState?.save();
                                      print('phone and password aeaeaeae : $_phoneNumber : $_password');
                                      signIn(context, "doctor");
                                    }
                                  },
                                  child:  Padding(
                                    padding:  EdgeInsets.only(top:10.w,bottom: 10.w),
                                    child: Text(
                                      "Doctor",
                                      style: TextStyle(
                                          color: Colors.white,

                                          fontWeight: FontWeight.w600,
                                          fontSize: 22.sp),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex:1,
                            child: Padding(
                              padding: EdgeInsets.only(left: 10.w),
                              child: Container(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    // Background color
                                    shadowColor: Colors.grey,
                                    // Shadow color
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.w)),
                                  ),
                                  onPressed: () {
                                    if (formKey.currentState?.validate() ??
                                        false) {
                                      formKey.currentState?.save();
                                      print('phone and password aeaeaeae : $_phoneNumber : $_password');
                                      signIn(context, "patient");
                                    }
                                  },
                                  child:  Padding(
                                    padding: EdgeInsets.only(top:10.w,bottom: 10.w),
                                    child: Text(
                                      "Patient",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 22.sp),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 40.w),
                      child: RichText(
                        text: TextSpan(
                          text: "Doesn't have an account?  ",
                          style: TextStyle(
                              fontSize: 15.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          children: <TextSpan>[
                            TextSpan(
                              text: "Sign up ",
                              style: TextStyle(
                                  fontSize: 15.sp,
                                  color: Color.fromRGBO(7, 197, 227, 1.0),
                                  fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Navigate to the login page when tapped
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignInscreen()),
                                    (route) => route.isFirst,
                                  );
                                },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
