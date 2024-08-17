import 'package:abin/colors.dart';
import 'package:abin/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // form state
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? _email;
  String? _number;


  void signIn(BuildContext context) async {
    try {
      var authUser = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email!, password: _number!);
      if (authUser.user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } catch (e) {
      String errorMessage;
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'No user found for this Email.';
            break;
          case 'wrong-password':
            errorMessage = 'Password is Wrong.';
            break;
          case 'invalid-email':
            errorMessage = 'Invalid Email Address.';
            break;
          default:
            errorMessage = 'Error. Please Try Again.';
        }
      } else {
        errorMessage = 'Error. Please Try Again.';
      }
      _showErrorDialog(context, errorMessage);
    }
  }

  //error in login
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Log In Error',
          style: TextStyle(color: primaryColor),),

          content: Text(message,
          style: TextStyle(color: primaryColor),),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height; // full screen height
    double width = MediaQuery.of(context).size.width; // full screen width
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
              child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.only(left:30,right:30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top:100),
                            child: Center(child: SvgPicture.asset("assets/login.svg",height: 200,)),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: height * 0.35),
                            child: Center(
                              child: Text(
                                "Welcome Back",
                                style: TextStyle(
                                    fontSize: 34,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor // bold font
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: height * 0.44),
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
                            padding: EdgeInsets.only(top: height * 0.54),
                            child: TextFormField(
                              onSaved: (value) {
                                _number = value;
                              },
                              validator: (number) {
                                if (number == null || number.isEmpty) {
                                  return "Please Enter the Password";
                                } else if (number.length  <6) {
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
                          Padding(
                            padding: EdgeInsets.only(top: height * 0.65),
                            child: Center(
                              child: SizedBox(
                                height: height * 0.06,
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
                                      signIn(context);
                                    }
                                  },
                                  child: Text(
                                    "Log in",
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
                ),
              ),
          ),
        ),
      ),
    );
  }
}
