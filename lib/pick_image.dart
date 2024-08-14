import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickImage extends StatelessWidget {

  selectImage ()async{
    return showDialog(context: context, builder: (BuildContext context)){
      return SimpleDialog(
        title: Text(Add photo'),
      )
    }
  }

  @override
  State<PickImage> createState() => _PickImageState();
}

  Widget build(BuildContext context){
    return Scaffold(
      body:
      Center(child: Text("WELCOME HOME"),
      ),
    );
  }
}