import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AlertDialogPrescription_duration extends StatefulWidget {
  const AlertDialogPrescription_duration({super.key});

  @override
  State<StatefulWidget> createState() => AlertDialogPrescriptionState_duration();
}

class AlertDialogPrescriptionState_duration extends State<AlertDialogPrescription_duration> {
  String dropdownvalue_duration ="days";
  String heading = "Duration of intake";
  TextEditingController controller_duration=TextEditingController(text: "3");

  var periods= [
    'days',
    'months',
    'year',
    'weeks'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom:10.w),
          child: Text(heading,style: TextStyle(fontSize: 15.sp,color: Colors.black,fontWeight: FontWeight.bold),),
        ),
        Row(
          children: [
            Expanded(
              flex:1,
              child: Padding(
                padding:  EdgeInsets.only(right:5.w),
                child: Container(
                  decoration: BoxDecoration(border: Border.all(color: Colors.black45,),borderRadius: BorderRadius.circular(5.w)),
                  child: Center(
                    child: TextField(
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15.sp,color: Colors.black),
                      controller: controller_duration,
                      maxLines: 1,
                      keyboardType: const TextInputType.numberWithOptions(),
                    )
                  ),
                ),
              ),
            ),
            Expanded(
              flex:1,
              child: Container(
                decoration: BoxDecoration(border: Border.all(color: Colors.black45,),borderRadius: BorderRadius.circular(5.w)),
                child: Center(
                  child: DropdownButton(
                    value: dropdownvalue_duration,
                    items: periods.map(
                          (String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      },
                    ).toList(),
                    onChanged: (String? newValue) {
                      setState(
                            () {
                                dropdownvalue_duration = newValue!;

                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),

        Padding(
          padding: EdgeInsets.only(top:10.w),
          child: TextButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(3.w))
            ),
            onPressed: () {
                Navigator.pop(context, "${controller_duration.text.toString()} $dropdownvalue_duration");
            },
            child:  Padding(
              padding:  EdgeInsets.only(top:3.w,bottom:3.w,left:9.w,right:9.w),
              child: Text("Save",style: TextStyle(fontSize: 15.sp,color: Colors.white),),
            ),
          ),
        )
      ],
    );
  }
}
