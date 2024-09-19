import 'package:abin/colors.dart';
import 'package:abin/flashscreen.dart';
import 'package:abin/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'Doctor.dart';
import 'Pat_homescreen.dart';

class SignInscreen extends StatefulWidget {
  const SignInscreen({super.key});

  @override
  State<SignInscreen> createState() => _SignInscreenState();
}

class _SignInscreenState extends State<SignInscreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.reference();
  final TextEditingController _dateController = TextEditingController();

  String? _email;
  String? _number;
  String? _password;
  String? _name;
  String? _birth;
  String? _gender;
  String? _userType;

  void _registerUser(BuildContext context, String userType) async {
    _userType = userType;
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _email!,
          password: _password!,
        );

        // Save user data to Firebase Realtime Database
        DatabaseReference usersRef = _database.child('users');
        Map<String, dynamic> userData = {
          "uid": userCredential.user!.uid,
          "name": _name!,
          "email": _email!,
          "phoneNumber": _number!,
          "birthDate": _birth!,
          "gender": _gender!,
          "userType": _userType!,
        };
        await usersRef.child(_number!).set(userData);

        print('User registered: ${userCredential.user?.email}');
        // Navigate to the respective screen based on user type
        if (_userType == 'doctor') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DoctorScreen(userId: userCredential.user!.uid),
            ),
          );
        } else if (_userType == 'patient') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PatHomeScreen()),
          );
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage =
                'The email address is already in use by another account.';
            break;
          case 'invalid-email':
            errorMessage = 'The email address is not valid.';
            break;
          case 'operation-not-allowed':
            errorMessage = 'Email/password accounts are not enabled.';
            break;
          case 'weak-password':
            errorMessage = 'The password is too weak.';
            break;
          default:
            errorMessage = 'An unknown error occurred.';
        }
        print('Error: $e');
        // Show error message

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(errorMessage)));
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('An unknown error occurred.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height; // full screen height
    double width = MediaQuery.of(context).size.width; // full screen width
    return Scaffold(
      backgroundColor: const Color(0xFFF4F2F2),
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
                                    primary: primaryColor,
                                    // header background color
                                    onPrimary: Colors.white,
                                    // header text color
                                    surface: Color(0xFFBBDEFB),
                                    // background color
                                    onSurface: primaryColor, // text color
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (selectedDate != null) {
                            String formattedDate =
                                DateFormat('MM/dd/yyyy').format(selectedDate);
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
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginScreen()), (route) => route.isFirst,);
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
