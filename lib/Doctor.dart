import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';
import 'Doc_homescreen.dart';
import 'colors.dart';

class DoctorScreen extends StatefulWidget {
  final String userId;

  const DoctorScreen({Key? key, required this.userId}) : super(key: key);

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
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        setImage(File(pickedFile.path));
        _idProofImageName = pickedFile.path.split('/').last; // Get the file name
      });
    }
  }

  Future<String?> _uploadImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final uploadTask = storageRef.child('user_id_photos/${widget.userId}').putFile(image);
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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DocHomeScreen(),
        ),
      );
      String? idProofUrl;

      // Check if ID proof image is selected
      if (_idProofImage != null) {
        idProofUrl = await _uploadImage(_idProofImage!);
      }

      try {
        // Update user data in the Realtime Database
        await FirebaseDatabase.instance.reference().child('users').child(widget.userId).update({
          'license': _license,
          'specialization': _special,
          'years_of_experience': _years,
        });

        // Save the ID photo URL to Firestore
        await FirebaseFirestore.instance.collection('users').doc(widget.userId).update({
          'id_proof_image': idProofUrl,
        });


      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height; // full screen height
    double width = MediaQuery.of(context).size.width; // full screen width
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFFF),
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
                           padding: EdgeInsets.only(top: height* 0.06),
                           child: SvgPicture.asset(
                              "assets/image1.svg",
                              height: height * 0.33,
                            ),
                         ),
                       ),


                    Padding(
                      padding: EdgeInsets.only(
                          left: width*0.02,top: height *0.35),
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
                        decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: primaryColor)),
                            prefixIcon: Icon(Icons.badge, color: primaryColor),
                            labelText: "MEDICAL LICENCE NUMBER",
                            labelStyle: TextStyle(
                                color: primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: width*0.02,top: height *0.45),
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
                        decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: primaryColor)),
                            prefixIcon: Icon(Icons.medical_services, color: primaryColor),
                            labelText: "SPECIALIZATION",
                            labelStyle: TextStyle(
                                color: primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: width*0.02,top: height *0.55),
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
                        decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: primaryColor)),
                            prefixIcon: Icon(Icons.access_time, color: primaryColor),
                            labelText: "YEARS OF EXPERIENCE",
                            labelStyle: TextStyle(
                                color: primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: width*0.02,top: height *0.68),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black38),
                          borderRadius: BorderRadius.circular((10)),
                        ),
                        child: ListTile(
                          leading: GestureDetector(
                            onTap: () => _pickImage((file) {
                              setState(() {
                                _idProofImage = file;
                              });
                            }),
                            child: Icon(Icons.photo, color: primaryColor),
                          ),
                          title: Text("UPLOAD ID PROOF (Optional)",
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: _idProofImageName != null
                              ? Text(_idProofImageName!) // Show the selected image file name
                              : null,
                          trailing: Icon(Icons.arrow_forward_ios, color: primaryColor),
                          onTap: () {
                            _pickImage((file) {
                              setState(() {
                                _idProofImage = file;
                                _idProofImageName = file!.path.split('/').last; // Get the file name
                              });
                            });
                          },
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: height *0.85),
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
                                  _saveData(context);
                                },
                                child: Text(
                                "SIGN UP",
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
