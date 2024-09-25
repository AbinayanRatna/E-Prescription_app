import 'package:abin/admin_page.dart';
import 'package:abin/doc_homescreen.dart';
import 'package:abin/pat_homescreen.dart';
import 'package:abin/signinpage.dart';
import 'package:abin/colors.dart';
import 'package:abin/userlogmodel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Form state 
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // Variables 
  String? _phoneNumber;
  String? _password;
  var userBox=Hive.box<UserDetails>('User');

  // Handling sign-in process
  Future<void> signIn(BuildContext context,String userType) async {
    //reference to the firebase db based on user type
    DatabaseReference dbref=FirebaseDatabase.instance.ref().child("${userType}/${_phoneNumber}");
    //fetch account from firebase
    DatabaseEvent accountEvent=await dbref.once();
    DataSnapshot accountSnapshot=accountEvent.snapshot;
    //checking account is exist 
    if(accountSnapshot.value != null){
      // fetch password and username 
      DatabaseEvent passwordEvent=await dbref.child("password").once();
      DatabaseEvent nameEvent=await dbref.child("name").once();
      DataSnapshot passwordSnapshot=passwordEvent.snapshot;
      DataSnapshot nameSnapshot=nameEvent.snapshot;
      //Check if the password is correct
      if(_password == passwordSnapshot.value){
        if(userType=="doctor"){
          UserDetails userOfApp=UserDetails(user_phone: _phoneNumber!, user_type: "doctor", user_logout: false,userHospitalNow: "No hospital",userName:nameSnapshot.value.toString() );
          userBox.add(userOfApp);
          Navigator.push(context, MaterialPageRoute(builder: (context)=>DocHomescreen(phoneNumber: _phoneNumber!,)));
        }
        else if(userType=="patient"){
          UserDetails userOfApp=UserDetails(user_phone: _phoneNumber!, user_type: "patient", user_logout: false,userHospitalNow: "No hospital",userName:nameSnapshot.value.toString());
          userBox.add(userOfApp);
          Navigator.push(context, MaterialPageRoute(builder: (context)=>PatHomeScreen(phoneNumber: _phoneNumber!,)));
        }
      }
      else{
        _showErrorDialog(context, "Incorrect Password");
      }
    }
    else{
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
                                  onPressed: () async {
                                    if (formKey.currentState?.validate() ??
                                        false) {
                                      formKey.currentState?.save();
                                      print('phone and password aeaeaeae : $_phoneNumber : $_password');

                                      if(_phoneNumber=="0000000000" && _password=="ansansansans"){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const AdminPage()));
                                      }else{
                                        await signIn(context, "doctor");
                                      }
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
                                  onPressed: () async {
                                    if (formKey.currentState?.validate() ??
                                        false) {
                                      formKey.currentState?.save();
                                      print('phone and password aeaeaeae : $_phoneNumber : $_password');
                                      if(_phoneNumber=="0000000000" && _password=="ansansansans"){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const AdminPage()));
                                      }else{
                                        await signIn(context, "patient");
                                      }

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
