/*
// @dart=2.9
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
void main() => runApp(Example());

class Example extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
                title: Text('TFLite Example'),
                backgroundColor: Colors.transparent
            ),
            body: Center(
                child: MyImagePicker()
            )
        )
    );
  }
}


class MyImagePicker extends StatefulWidget {
  @override
  MyImagePickerState createState() => MyImagePickerState();
}

class MyImagePickerState extends State {

  File imageURI;
  String result;
  String path;

  Future getImageFromCamera() async {

    var pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    final File file = File(pickedFile.path);
    setState(() {
      imageURI = file;
      path = file.path;
    });
  }

  Future getImageFromGallery() async {

    var pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    final File file = File(pickedFile.path);
    setState(() {
      imageURI = file;
      path = file.path;
    });
  }

  Future classifyImage() async {

    await Tflite.loadModel(model: "assets/models/model.tflite",labels: "assets/models/labels.txt");
    var output = await Tflite.runModelOnImage(path: path);

    setState(() {
      result = output.toString();
    });


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  imageURI == null
                      ? Text('No image selected.')
                      : Image.file(imageURI, width: 300, height: 200, fit: BoxFit.cover),

                  Container(
                      margin: EdgeInsets.fromLTRB(0, 30, 0, 20),
                      child: RaisedButton(
                        onPressed: () => getImageFromCamera(),
                        child: Text('Click Here To Select Image From Camera'),
                        textColor: Colors.white,
                        color: Colors.blue,
                        padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                      )),

                  Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: RaisedButton(
                        onPressed: () => getImageFromGallery(),
                        child: Text('Click Here To Select Image From Gallery'),
                        textColor: Colors.white,
                        color: Colors.blue,
                        padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                      )),

                  Container(
                      margin: EdgeInsets.fromLTRB(0, 30, 0, 20),
                      child: RaisedButton(
                        onPressed: () => classifyImage(),
                        child: Text('Classify Image'),
                        textColor: Colors.white,
                        color: Colors.blue,
                        padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                      )),

                  result == null
                      ? Text('Result')
                      : Text(result)
                ]))
    );
  }
}
 */
