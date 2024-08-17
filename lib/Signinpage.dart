import 'package:abin/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Doctor.dart';
import 'Pat_homescreen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import'package:flutter_date_pickers/flutter_date_pickers.dart' as fdp;



class SignInscreen extends StatefulWidget {
  const SignInscreen({super.key});

  @override
  State<SignInscreen> createState() => _SignInscreenState();
}

class _SignInscreenState extends State<SignInscreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.reference();
  TextEditingController _dateController = TextEditingController();

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
        await usersRef.child(userCredential.user!.uid).set(userData);

        print('User registered: ${userCredential.user?.email}');
        // Navigate to the respective screen based on user type
        if (_userType == 'doctor') {
          Navigator.push(
            context,

            MaterialPageRoute(builder: (context) => DoctorScreen(userId: userCredential.user!.uid),),
          );
        } else if (_userType == 'patient') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PatHomeScreen()),
          );
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        switch (e.code) {
          case 'email-already-in-use':

            errorMessage = 'The email address is already in use by another account.';
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
            SnackBar(content: Text('An unknown error occurred.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height; // full screen height
    double width = MediaQuery.of(context).size.width; // full screen width
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: height * 0.09),
                        child: Text(
                          "Create an account",
                          style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: primaryColor // bold font
                              ),
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: height*0.16),
                        child: Text(
                          "Welcome to E-Prescription!",
                          style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                              color: primaryColor // bold font
                              ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: width * 0.02, top: height * 0.24),
                      child: TextFormField(

                        onSaved: (value) {
                          _name = value;
                        },
                        validator: (name) {
                          if (name == null || name.isEmpty) {
                            return "Please Enter the Your Name";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: primaryColor)),
                            prefixIcon: Icon(Icons.person, color: primaryColor),
                            labelText: "FULL NAME",
                            labelStyle: TextStyle(
                                color: primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: width * 0.02, top: height * 0.34),
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
                        decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: primaryColor)),
                            prefixIcon:
                            Icon(Icons.phone, color: primaryColor),
                            labelText: "PHONE NUMBER",
                            labelStyle: TextStyle(
                                color: primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: width*0.02,top: height *0.44),
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
                        decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: primaryColor)),
                            prefixIcon: Icon(Icons.date_range, color: primaryColor),
                            labelText: "DATE OF BIRTH",
                            labelStyle: TextStyle(
                                color: primaryColor,
                                fontSize: 16,
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
                                  colorScheme: ColorScheme.light(
                                    primary: primaryColor, // header background color
                                    onPrimary: Colors.white, // header text color
                                    surface: Color(0xFFBBDEFB), // background color
                                    onSurface: primaryColor, // text color
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (selectedDate != null) {
                            String formattedDate = DateFormat('MM/dd/yyyy').format(selectedDate);
                            setState(() {
                              _dateController.text = formattedDate;
                            });
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: width * 0.02, top: height * 0.54),
                      child: DropdownButtonFormField<String>(
                        value: _gender,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                          prefixIcon: Icon(Icons.wc, color: primaryColor),
                          labelText: "GENDER",
                          labelStyle: TextStyle(
                            color: primaryColor,
                            fontSize: 16,
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
                              style: TextStyle(fontWeight: FontWeight.w400), //
                              //
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: width * 0.02, top: height * 0.64),
                      child: TextFormField(
                        onSaved: (value) {
                          _email = value;
                        },
                        validator: (email) {
                          if (email == null || email.isEmpty) {
                            return "Please Enter the Email";
                          } else if (!RegExp(
                                  r'^[a-zA-Z0-9]+(?:[._%+-][a-zA-Z0-9]+)*@[a-zA-Z0-9]+(?:\.[a-zA-Z0-9]+)*(?:\.[a-zA-Z]{2,})$')
                              .hasMatch(email)) {
                            return "Not a valid Email Account";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: primaryColor)),
                            prefixIcon: Icon(Icons.email, color: primaryColor),
                            labelText: "EMAIL ADDRESS",
                            labelStyle: TextStyle(
                                color: primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsets.only(
                          left: width*0.02,top: height *0.74),
                      child: TextFormField(
                        onSaved: (value) {
                          _password = value;
                        },
                        validator: (password) {
                          if (password == null || password.isEmpty) {
                            return "Please Enter the Password";
                          } else if (password.length  <6) {
                            return "Not a valid Password";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: primaryColor)),
                            prefixIcon: Icon(Icons.lock, color: primaryColor),
                            labelText: "PASSWORD",
                            labelStyle: TextStyle(
                                color: primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: width*0.07,top: height *0.88),
                          child: Center(
                            child: SizedBox(
                              height: height * 0.07,
                              width: width * 0.4,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor, // Background color
                                  shadowColor: Colors.grey, // Shadow color
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13)),
                                ),
                                onPressed: () {
                                  if (formKey.currentState?.validate() ?? false) {
                                    formKey.currentState?.save();
                                    _registerUser(context,"doctor");
                                  }
                                },
                                child: Text(
                                  "Doctor",
                                  style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 0.7,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 22),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: width*0.065,top: height *0.88),
                          child: Center(
                            child: SizedBox(
                              height: height * 0.07,
                              width: width * 0.4,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor, // Background color
                                  shadowColor: Colors.grey, // Shadow color
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13)),
                                ),
                                onPressed: () {
                                  if (formKey.currentState?.validate() ?? false) {
                                    formKey.currentState?.save();
                                    _registerUser(context, "patient"); // Pass user type as "patient"
                                  }
                                },
                                child: Text(
                                  "Patient",
                                  style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 0.7,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 22),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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