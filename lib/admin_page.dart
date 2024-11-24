import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors.dart';
import 'login_screen.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<StatefulWidget> createState() => _adminPageState();
}

class _adminPageState extends State<AdminPage> {
  Future<void> removeDuplicateMedicines() async {
    DatabaseReference dbRef =
        FirebaseDatabase.instance.ref().child("medicines");
    DatabaseEvent event = await dbRef.once();
    DataSnapshot snapshot = event.snapshot;

    if (snapshot.value != null) {
      Map<dynamic, dynamic> medicines = snapshot.value as Map<dynamic, dynamic>;
      Map<String, dynamic> uniqueMedicines =
          {}; // To store unique medicine entries

      // Iterate over all medicines
      medicines.forEach((key, value) {
        String uniqueKey =
            '${value['medicine_name']}-${value['dosage']}'; // Create a unique identifier
        if (!uniqueMedicines.containsKey(uniqueKey)) {
          uniqueMedicines[uniqueKey] =
              key; // Store the key to keep track of unique entries
        } else {
          // Duplicate found, remove it from Firebase
          dbRef.child(key).remove();
          print('Removed duplicate entry with key: $key');
        }
      });
    }
  }

  Future<void> updateSyncOption() async {
    DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("doctor");
    DatabaseEvent event = await dbRef.once();
    DataSnapshot snapshot = event.snapshot;

    if (snapshot.value != null) {
      Map<dynamic, dynamic> medicines = snapshot.value as Map<dynamic, dynamic>;

      // Iterate over all medicines
      medicines.forEach((key, value) {
        dbRef.child(key).update({'syncAvailable': 'yes'});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Icon(
              Icons.person,
              color: Color.fromRGBO(6, 83, 94, 1.0),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: Text(
                  "Welcome admin",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ),
        toolbarHeight: 60.w,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15.w, left: 10.w),
            child: InkWell(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false,
                );
              },
              child: Container(
                width: 35.w,
                height: 35.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: const Icon(
                  Icons.logout,
                  // color: Color.fromRGBO(9, 75, 75, 1.0),
                  color: Color.fromRGBO(3, 152, 175, 1.0),
                ),
              ),
            ),
          ),
        ],
        backgroundColor: primaryColor,
      ),
      backgroundColor: const Color.fromRGBO(236, 230, 230, 1.0),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              color: primaryColor, borderRadius: BorderRadius.circular(20.w)),
          child: IconButton(
            onPressed: () async {
              await removeDuplicateMedicines().then((onValue) async {
                await updateSyncOption();
              });
            },
            icon: Icon(
              Icons.update,
              color: Colors.white,
              size: 150.w,
            ),
          ),
        ),
      ),
    );
  }
}
