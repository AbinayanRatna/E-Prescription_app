import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';
import 'Doc_homescreen.dart';
import 'colors.dart';

class DoctorScreen extends StatefulWidget {
  final String userId;

  const DoctorScreen({super.key, required this.userId});

  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  // form state
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? _license;
  String? _special;
  String? _years;

  final ImagePicker _picker = ImagePicker();
  File? _idProofImage;
  String? _idProofImageName;

  Future<void> _pickImage(Function(File?) setImage) async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        setImage(File(pickedFile.path));
        _idProofImageName =
            pickedFile.path.split('/').last; // Get the file name
      });
    }
  }

  Future<String?> _uploadImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final uploadTask =
          storageRef.child('doctor/${widget.userId}').putFile(image);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _saveData(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();

      String? idProofUrl;

      // Check if ID proof image is selected
      if (_idProofImage != null) {
        idProofUrl = await _uploadImage(_idProofImage!);
      }else{
        idProofUrl="not added";
      }

      try {
        // Update user data in the Realtime Database
        await FirebaseDatabase.instance
            .ref()
            .child('doctor')
            .child(widget.userId)
            .update({
          'license': _license,
          'specialization': _special,
          'years_of_experience': _years,
          'id_proof_image':idProofUrl
        });

      } catch (e) {
        print(e);
      }
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => DocHomeScreen()),
        (route) => route.isFirst,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1EEEE),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding:  EdgeInsets.only(left:25.w,right:25.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding:  EdgeInsets.only(top:100.w),
                    child: RichText(
                      text: TextSpan(
                          text: "Doctor ",
                          style: TextStyle(
                              fontSize: 35.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: "Details ",
                              style: TextStyle(
                                  fontSize: 35.sp,
                                  color: Color.fromRGBO(7, 197, 227, 1.0),
                                  fontWeight: FontWeight.bold
                              ),
                            )
                          ]
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top:40.w),
                    child: TextFormField(
                      onSaved: (value) {
                        _license = value;
                      },
                      validator: (license) {
                        if (license == null || license.isEmpty) {
                          return "Please Enter the Medical License Number";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.phone,
                      decoration:  InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.all(Radius.circular(20.w))
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color.fromRGBO(
                                  7, 40, 64, 1.0)),
                              borderRadius: BorderRadius.all(Radius.circular(20.w))
                          ),
                          prefixIcon:const  Icon(Icons.badge, color: Colors.black38),
                          labelText: "MEDICAL LICENCE NUMBER",
                          filled: true,
                          fillColor: Colors.white,
                          labelStyle: TextStyle(
                              color: Colors.black45,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top:30.w),
                    child: TextFormField(
                      onSaved: (value) {
                        _special = value;
                      },
                      validator: (special) {
                        if (special == null || special.isEmpty) {
                          return "Please Enter Your Specialization";
                        }
                        return null;
                      },
                      decoration:  InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.all(Radius.circular(20.w))
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color.fromRGBO(
                                  7, 40, 64, 1.0)),
                              borderRadius: BorderRadius.all(Radius.circular(20.w))
                          ),
                          prefixIcon:
                              const Icon(Icons.medical_services, color: Colors.black38),
                          labelText: "SPECIALIZATION",
                          filled: true,
                          fillColor: Colors.white,
                          labelStyle: TextStyle(
                              color: Colors.black45,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top:30.w),
                    child: TextFormField(
                      onSaved: (value) {
                        _years = value;
                      },
                      validator: (years) {
                        if (years == null || years.isEmpty) {
                          return "Please Enter the years Of Experience";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration:  InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.all(Radius.circular(20.w))
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color.fromRGBO(
                                  7, 40, 64, 1.0)),
                              borderRadius: BorderRadius.all(Radius.circular(20.w))
                          ),
                          prefixIcon:
                              const Icon(Icons.access_time, color: Colors.black38),
                          labelText: "YEARS OF EXPERIENCE",
                          filled: true,
                          fillColor: Colors.white,
                          labelStyle: TextStyle(
                              color: Colors.black45,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top:50.w),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.circular((20.w)),
                      ),
                      child: ListTile(
                        leading: GestureDetector(
                          onTap: () => _pickImage((file) {
                            setState(() {
                              _idProofImage = file;
                            });
                          }),
                          child: const Icon(Icons.photo, color: Colors.black54),
                        ),
                        title: const Text(
                          "UPLOAD ID PROOF (Optional)",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: _idProofImageName != null
                            ? Text(
                                _idProofImageName!) // Show the selected image file name
                            : null,
                        trailing: const Icon(Icons.arrow_forward_ios,
                            color: Colors.black54),
                        onTap: () {
                          _pickImage((file) {
                            setState(() {
                              _idProofImage = file;
                              _idProofImageName =
                                  file!.path.split('/').last; // Get the file name
                            });
                          });
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30.w),
                    child: Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor, // Background color
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13.w)),
                        ),
                        onPressed: () {
                          _saveData(context);
                        },
                        child:  Padding(
                          padding:  EdgeInsets.only(top:10.w,bottom: 10.w),
                          child: Text(
                            "SIGN UP",
                            style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 0.7,
                                fontWeight: FontWeight.w600,
                                fontSize: 20.sp),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
