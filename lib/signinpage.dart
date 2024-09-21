import 'package:abin/colors.dart';
import 'package:abin/login_screen.dart';
import 'package:abin/userlogmodel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'doctor_signup.dart';
import 'pat_homescreen.dart';

class SignInscreen extends StatefulWidget {
  const SignInscreen({super.key});

  @override
  State<SignInscreen> createState() => _SignInscreenState();
}

class _SignInscreenState extends State<SignInscreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();

  String? _number;
  String? _password;
  String? _name;
  String? _birth;
  String? _gender;
  String? _userType;
  var userBox=Hive.box<UserDetails>('User');

  void _registerUser(BuildContext context, String userType) async {
    _userType = userType;
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      try {
        // Save user data to Firebase Realtime Database
        DatabaseReference usersRef = FirebaseDatabase.instance.ref().child('$userType');
        Map<String, dynamic> userData = {
          "name": _name!,
          "phoneNumber": _number!,
          "birthDate": _birth!,
          "password":_password!,
          "gender": _gender!,
          "userType": _userType!,
        };
        await usersRef.child(_number!).set(userData);

        if (kDebugMode) {
          print('$userType registered: ${_number} - is added');
        }
        // Navigate to the respective screen based on user type
        if (_userType == 'doctor') {
          UserDetails userOfApp=UserDetails(user_phone: _number!, user_type: "doctor", user_logout: false,userHospitalNow: "No hospital");
          userBox.add(userOfApp);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DoctorScreen(userId: _number!),
            ),
          );
        } else if (_userType == 'patient') {
          UserDetails userOfApp=UserDetails(user_phone: _number!, user_type: "patient", user_logout: false,userHospitalNow: "No hospital");
          userBox.add(userOfApp);
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>PatHomeScreen(phoneNumber: _number!,)), (route) => route.isFirst,);

        }
      } on FirebaseException catch (e) {
        if(kDebugMode){
          print('Error: $e');
        }

      } catch (e) {
        if(kDebugMode){
          print('Error: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height; // full screen height
    double width = MediaQuery.of(context).size.width; // full screen width
    return Scaffold(
      backgroundColor: const Color(0xFFF1EEEE),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          width: width,
          height: height,
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                       padding:  EdgeInsets.only(top:height/7),
                       child: RichText(
                         text: TextSpan(
                           text: "Create ",
                           style: TextStyle(
                             fontSize: 35.sp,
                             color: Colors.black,
                             fontWeight: FontWeight.bold
                           ),
                           children: <TextSpan>[
                             TextSpan(
                               text: "Account ",
                               style: TextStyle(
                                   fontSize: 35.sp,
                                   color: Color.fromRGBO(7, 197, 227, 1.0),
                                   fontWeight: FontWeight.bold
                               ),
                             )
                           ]
                         ),
                                       ),
                     ),
                    Padding(
                      padding:  EdgeInsets.only(top:30.w,left: 25.w,right: 25.w),
                      child: TextFormField(
                        onSaved: (value) {
                          if(value != ""){
                            _name = value!.trim().toString();
                          }
                        },
                        validator: (name) {
                          if (name == null || name.isEmpty) {
                            return "Please Enter the Your Name";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.name,
                        decoration:  InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.all(Radius.circular(20.w))
                          ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color.fromRGBO(
                                  7, 40, 64, 1.0)),
                              borderRadius: BorderRadius.all(Radius.circular(20.w))
                            ),
                            prefixIcon: const Icon(Icons.person, color: Colors.black38),
                            labelText: "FULL NAME",
                            filled: true,
                            fillColor: Colors.white,
                            labelStyle: TextStyle(
                                color: Colors.black45,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top:15.w,left: 25.w,right: 25.w),
                      child: TextFormField(
                        onSaved: (value) {
                          _number = value;
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
                        decoration:  InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.all(Radius.circular(20.w))
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color.fromRGBO(
                                  7, 40, 64, 1.0)),
                              borderRadius: BorderRadius.all(Radius.circular(20.w))
                          ),
                          prefixIcon: const Icon(Icons.phone, color: Colors.black38),
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
                      padding: EdgeInsets.only(top:15.w,left: 25.w,right: 25.w),
                      child: TextFormField(
                        controller: _dateController,
                        onSaved: (value) {
                          _birth = value;
                        },
                        validator: (birth) {
                          if (birth == null || birth.isEmpty) {
                            return "Please Enter the Date Of Birth";
                          }
                          return null;
                        },
                        readOnly: true,
                        decoration:  InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.black12),
                                borderRadius: BorderRadius.all(Radius.circular(20.w))
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color.fromRGBO(
                                    7, 40, 64, 1.0)),
                                borderRadius: BorderRadius.all(Radius.circular(20.w))
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon:
                                const Icon(Icons.date_range, color: Colors.black38),
                            labelText: "DATE OF BIRTH",
                            labelStyle: TextStyle(
                                color: Colors.black45,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600)),
                        onTap: () async {
                          DateTime? selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900, 1, 1),
                            lastDate: DateTime.now(),
                            builder: (BuildContext context, Widget? child) {
                              return Theme(
                                data: ThemeData.light().copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: primaryColor,          // Header background color
                                    onPrimary: Colors.white,       // Header text color
                                    surface: Colors.white,    // Background color
                                    onSurface: Colors.black,       // Text color inside calendar
                                  ),
                                  dialogBackgroundColor: Colors.white,  // Background color of the dialog
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (selectedDate != null) {
                            String formattedDate =
                                DateFormat('dd/MM/yyyy').format(selectedDate);
                            setState(() {
                              _dateController.text = formattedDate;
                            });
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top:15.w,left: 25.w,right: 25.w),
                      child: DropdownButtonFormField<String>(
                        value: _gender,
                        decoration:  InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.all(Radius.circular(20.w))
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color.fromRGBO(
                                  7, 40, 64, 1.0)),
                              borderRadius: BorderRadius.all(Radius.circular(20.w))
                          ),
                          prefixIcon: const Icon(Icons.wc, color: Colors.black38),
                          labelText: "GENDER",
                          filled: true,
                          fillColor: Colors.white,
                          labelStyle: TextStyle(
                            color: Colors.black45,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _gender = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select your gender';
                          }
                          return null;
                        },
                        items: <String>['Male', 'Female', 'Other']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15.sp), //
                              //
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top:15.w,left: 25.w,right: 25.w),
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
                        decoration:  InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.black12),
                                borderRadius: BorderRadius.all(Radius.circular(20.w))
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color.fromRGBO(
                                    7, 40, 64, 1.0)),
                                borderRadius: BorderRadius.all(Radius.circular(20.w))
                            ),
                            prefixIcon: const Icon(Icons.lock, color: Colors.black38),
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
                      padding: EdgeInsets.only(top:25.w,left: 25.w,right: 25.w),
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
                                      _registerUser(context, "doctor");
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
                                      _registerUser(context, "patient"); // Pass user type as "patient"
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
                      padding:  EdgeInsets.only(top:20.w),
                      child: RichText(
                        text: TextSpan(
                            text: "Already have an account?  ",
                            style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: "Log in ",
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    color: Color.fromRGBO(7, 197, 227, 1.0),
                                    fontWeight: FontWeight.bold
                                ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Navigate to the login page when tapped
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginScreen()), (route) => false,);
                            },
                              )
                            ]
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

class User {
  final String uid;
  final String name;
  final String email;
  final String phoneNumber;
  final String birthDate;
  final String gender;

  User({
    required this.uid,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.birthDate,
    required this.gender,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'birthDate': birthDate,
      'gender': gender,
    };
  }
}
