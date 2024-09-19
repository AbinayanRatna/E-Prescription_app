import 'package:abin/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'Signinpage.dart';
import 'constans.dart';
import 'login_screen.dart';

class FlashScreen extends StatefulWidget {
  const FlashScreen({super.key});

  @override
  State<FlashScreen> createState() => _FlashScreenState();
}

class _FlashScreenState extends State<FlashScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height; //full screen height
    double width = MediaQuery.of(context).size.width; //full screen width
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        //align widgets from left side
        mainAxisAlignment: MainAxisAlignment.start,
        //align the children widgets from the start
        children: <Widget>[
          Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 0, right: 0, left: 0),
                child: SvgPicture.asset("assets/ellipse1.svg",
                    width: width * 0.4, height: 0.41 * height),
              ),
              Padding(
                padding: EdgeInsets.only(top: height * 0.2),
                child: Center(
                  child: SvgPicture.asset("assets/Group.svg",
                      // fit: BoxFit.contain,
                      width: width,
                      height: 0.35 * height),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: height * 0.04),
            child: const Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: Text(
                      appName,
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: primaryColor //bold font
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                // Align items at the top
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: height * 0.08),
                    child: SizedBox(
                      height: height * 0.06,
                      width: width * 0.4,
                      child: ElevatedButton(
                        style:ElevatedButton.styleFrom(backgroundColor: primaryColor,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                        onPressed: () {
                          //next screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Log in",
                          style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.w400,
                              fontSize: 22),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: height * 0.05),
                    child: SizedBox(
                      height: height * 0.06,
                      width: width * 0.4,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)))
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignInscreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Sign up",
                          style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.w400,
                              fontSize: 22),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
