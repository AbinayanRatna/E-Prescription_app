
import 'package:abin/colors.dart';
import 'package:flutter/material.dart';

class PatHomeScreen extends StatefulWidget {
  const PatHomeScreen({super.key});

  @override
  State<PatHomeScreen> createState() => _PatHomeScreenState();
}

class _PatHomeScreenState extends State<PatHomeScreen> {
  // form state
  GlobalKey<FormState> formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height; // full screen height
    double width = MediaQuery.of(context).size.width; // full screen width
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
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
                        padding: EdgeInsets.only(top: height *0.5),
                        child: const Text(
                          "welcome patient",
                          style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              color: primaryColor // bold font
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
    );
  }
}
