import 'package:abin/doc_homescreen.dart';
import 'package:abin/pat_homescreen.dart';
import 'package:abin/login_screen.dart';
import 'package:abin/patientmodel.dart';
import 'package:abin/userlogmodel.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive database 
  await Hive.initFlutter();

  //hive adapters 
  Hive.registerAdapter(PatientAdapter());
  Hive.registerAdapter(MedicineAdapter());
  Hive.registerAdapter(UserDetailsAdapter());

  //opening hive boxes to store and reterive data
  await Hive.openBox<Patient>('Patients');
  await Hive.openBox<Medicine>('Medicines');
  await Hive.openBox<UserDetails>('User');

  //Initialize firebase
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (_, child) {
        return const MaterialApp(
          home: SplashScreen(),
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
    // Next screen
    _navigateToLoginScreen();
  }

  _navigateToLoginScreen() async {
    await Future.delayed(const Duration(seconds: 3), () {});

    // Retrieve the 'User' box from hive to check if there are any stored users
      var userBox=Hive.box<UserDetails>('User');

    // check if box is empty then goes login screen
      if(userBox.isEmpty){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    
    //if box is not empty, then check user type
      else if(userBox.isNotEmpty){
        UserDetails user = userBox.getAt(0)!;
    // If the user has not logged out, navigate to the appropriate home screen 
        if(user.user_logout == false){
          
          //if user is doctor then navigate doctor home screen
          if(user.user_type=='doctor'){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DocHomescreen(phoneNumber: user.user_phone)),
            );
          }
          //if user is patient then navigate patient home screen
          else if(user.user_type=='patient'){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PatHomeScreen(phoneNumber: user.user_phone)),
            );
          }
        }
      }
  }

  @override
  Widget build(BuildContext context) {
    // Full screen height
    double height = MediaQuery.of(context).size.height; 
     // Full screen width
    double width = MediaQuery.of(context).size.width;

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
