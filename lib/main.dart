import 'package:abin/Doc_homescreen.dart';
import 'package:abin/diagnosis_page.dart';
import 'package:abin/home_screen.dart';
import 'package:abin/prescription_writing_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'flashscreen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (_,child){
        return const MaterialApp(
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToFlashScreen();
  }

  _navigateToFlashScreen() async {
    await Future.delayed(Duration(seconds: 3), () {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DiagnosisPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height; // Full screen height
    double width = MediaQuery.of(context).size.width; // Full screen width

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          "assets/logo.png",
          width: width,
          height: 0.35 * height,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
