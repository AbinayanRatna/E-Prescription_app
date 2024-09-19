import 'package:abin/colors.dart';
import 'package:flutter/material.dart';

class DocHomeScreen extends StatefulWidget {
  const DocHomeScreen({super.key});

  @override
  State<DocHomeScreen> createState() => _DocHomeScreenState();
}

class _DocHomeScreenState extends State<DocHomeScreen> {
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
                        padding: EdgeInsets.only(top: height* 0.5),
                        child: const Text(
                          "welcome doctor",
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
