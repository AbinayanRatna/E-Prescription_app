import 'package:abin/Signinpage.dart';
import 'package:abin/flashscreen.dart';
import 'package:abin/login_screen.dart';
import 'package:abin/patientmodel.dart';
import 'package:abin/prescription_writing_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(PatientAdapter());
  Hive.registerAdapter(MedicineAdapter());
  await Hive.openBox<Patient>('Patients');
  await Hive.openBox<Medicine>('Medicines');
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (_, child) {
        return MaterialApp(
          routes: {
            'FlashScreen': (context) => FlashScreen(),
          },
          home: const SplashScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

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
    await Future.delayed(const Duration(seconds: 3), () {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => FlashScreen()),
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
