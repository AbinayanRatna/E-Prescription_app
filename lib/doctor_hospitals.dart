import 'package:abin/colors.dart';
import 'package:abin/userlogmodel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

/// Main class for the hospital selection screen
class DocHospitalSelectPage extends StatefulWidget {
  const DocHospitalSelectPage({super.key});

  @override
  State<StatefulWidget> createState() => DocHospitalSelectPageState();
}

class DocHospitalSelectPageState extends State<DocHospitalSelectPage> {
  // Reference to Firebase database
  DatabaseReference dbRefHospital = FirebaseDatabase.instance.ref();
  
  // Hive box for storing user details locally
  var userDetailsBox = Hive.box<UserDetails>("User");
  String phoneNumber = "";  // Stores the user's phone number
  late String uuid;   // Unique identifier for hospitals
  String hopitalNowIn = "None of the hospitals";  // Stores the name of the hospital the doctor is currently assigned to
  
  // Controller for the hospital name input field
  TextEditingController hospitalNameController = TextEditingController();

  @override
  void initState() {
    // Fetch the phone number from the local storage (Hive box)
    phoneNumber = userDetailsBox.getAt(0)!.user_phone;
    
    // Checking whether the doctor is currently assigned to a hospital
    if(userDetailsBox.getAt(0)!.userHospitalNow == "new"){
      hopitalNowIn = "None of the hospitals"; // Default if the doctor has no hospital
    } else {
      hopitalNowIn = userDetailsBox.getAt(0)!.userHospitalNow!; // Retrieve the hospital name from the user's details
    }
    
    // Set the Firebase database reference to the doctor's hospitals based on their phone number
    dbRefHospital = dbRefHospital.child("doctor/${phoneNumber}/hospitals");
    super.initState();
  }

  /// Display a list item for each hospital
  Widget listItem({required Map thisUserHospitals}) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.w),
      child: Container(
        decoration: BoxDecoration(
          // Light gray background
          color: Color.fromRGBO(229, 227, 221, 1.0),
          borderRadius: BorderRadius.circular(20.w)
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hospital name button
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.w),
                              bottomLeft: Radius.circular(20.w),
                              bottomRight: Radius.zero,
                              topRight: Radius.zero)),
                      elevation: (0),
                      padding: (EdgeInsets.only(top: 10.w, bottom: 10.w)),
                      backgroundColor: const Color.fromRGBO(5, 84, 97, 1.0)),
                  onPressed: () {},
                  child: Container(
                    child: Column(
                      children: [
                        // Display hospital name
                        Padding(
                          padding: EdgeInsets.only(top: 5.w, bottom: 5.w,right:5.w,left: 5.w),
                          child: Text(
                            thisUserHospitals['name'],  // Display hospital name from the Firebase snapshot
                            style: TextStyle(fontSize: 16.sp, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Button to allow the user to select a hospital
              Expanded(
                flex: 1,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20.w),
                                bottomRight: Radius.circular(20.w),
                                bottomLeft: Radius.zero,
                                topLeft: Radius.zero)),
                        elevation: (0),
                        padding: (EdgeInsets.only(top: 10.w, bottom: 10.w)),
                        backgroundColor:
                            const Color.fromRGBO(229, 227, 221, 1.0)),
                    onPressed: () {
                      setState(() {
                        hopitalNowIn = thisUserHospitals['name'];  // Update selected hospital name
                        
                        // Update the user's hospital information in Hive
                        UserDetails updatedUser = UserDetails(
                            user_phone: userDetailsBox.getAt(0)!.user_phone,
                            user_type: userDetailsBox.getAt(0)!.user_type,
                            user_logout: false,
                            userHospitalNow: thisUserHospitals['name'],
                          userName: userDetailsBox.getAt(0)!.userName
                        );
                        userDetailsBox.putAt(0, updatedUser);  // Save updated user details in Hive
                      });
                    },
                    child: Text(
                      "Select",  // Button to select the hospital
                      style: TextStyle(fontSize: 15.w, color: Colors.black),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        toolbarHeight: 60.w,
        title: Text(
          "Select hospital",  // Title of the page
          style: TextStyle(
              fontSize: 20.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            // Hospital name input field and "Add hospital" button
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.only(top: 10.w, right: 10.w, left: 10.w),
                child: Container(
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(213, 233, 239, 1.0),
                      borderRadius: BorderRadius.circular(20.w)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Label for hospital name field
                      Padding(
                        padding: EdgeInsets.only(left: 30.w, top: 20.w),
                        child: Text(
                          "Hospital name:",  // Label for the text input
                          style: TextStyle(
                              color: Color.fromRGBO(35, 35, 35, 1.0),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      // Text field for entering the hospital name
                      Padding(
                          padding: EdgeInsets.only(
                              top: 2.w, left: 30.w, right: 30.w),
                          child: TextField(
                            controller: hospitalNameController,  // Controller to capture hospital name input
                            decoration: const InputDecoration(
                                hintStyle: TextStyle(
                                    color: Color.fromRGBO(104, 196, 209, 1.0)),
                                hintText: "eg:- Royal hospital colombo"),  // Placeholder text
                            style: (TextStyle(
                                color: Colors.indigo, fontSize: 15.w)),
                          )),
                      // Button to add the hospital
                      Padding(
                        padding: EdgeInsets.only(top: 20.w, left: 30.w, right: 30.w),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.w))),
                          onPressed: () {
                            setState(() {
                              uuid = const Uuid().v4();  // Generate a unique ID for the hospital
                            });

                            // Create a map with hospital data
                            Map<String, String> doctorMapHospital = {
                              "name": hospitalNameController.text.trim().toString(),
                              "id": uuid,
                            };
                            // Store the hospital in Firebase
                            dbRefHospital.child(uuid).set(doctorMapHospital);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(top: 8.w, bottom: 8.w),
                            child: Text(
                              "Add hospital",  // Button to add the hospital
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Display currently selected hospital
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(top: 20.w, left: 15.w, right: 15.w),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.w),
                    color: Color.fromRGBO(222, 232, 232, 1.0),
                  ),
                  child: Padding(
                    padding:  EdgeInsets.only(left: 10.w, right: 10.w),
                    child: Center(
                      child: Text(
                        "$hopitalNowIn is selected",  // Display the currently selected hospital
                        style: TextStyle(color: Colors.black, fontSize: 16.sp),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // List of hospitals the doctor can choose from
            Expanded(
                flex: 4,
                child: FirebaseAnimatedList(
                  query: dbRefHospital,  // Firebase query to get the list of hospitals
                  itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                    Map userHospitals = snapshot.value as Map;  // Convert the snapshot to a Map
                    userHospitals['key'] = snapshot.key;
                    return listItem(thisUserHospitals: userHospitals);  // Display each hospital
                  },
                )),
          ],
        ),
      ),
    );
  }
}
