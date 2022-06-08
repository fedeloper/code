/*
import 'dart:developer' as developer;
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image/image.dart' as img;
import 'package:magic_mirror/magicmirror/cropper.dart';
import 'package:magic_mirror/searchstory/book.dart';
import 'package:magic_mirror/searchstory/repository.dart';
import 'package:magic_mirror/tellingthestory/tellingv2.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;

class MagicMirror2Widget extends StatefulWidget {
  @override
  _MagicMirror2Widget createState() => _MagicMirror2Widget();
}
final scaffoldKey = GlobalKey<ScaffoldState>();

class _MagicMirror2Widget extends State<MagicMirror2Widget> {
  FaceDetector faceDetector = GoogleMlKit.vision.faceDetector(FaceDetectorOptions(
    enableContours: true,
    enableClassification: true,
  ));
  bool isBusy = false;

  @override
  void dispose() {
    faceDetector.close();
    super.dispose();
  }

  Map<String, List<String>> emotion_corrispondece =
  {"Angry": ["The Man Who Knew Too Much"],
    "Disgust": ["Dr. Nikola’s Experiment"],
    "Fear": ["Has a Frog a Soul"],
    "Happy": ["Christmas Carol Collection 2009"],
    "Sad": ["Ghost Stories of an Antiquary"],
    "Surprise": ["The Secret Agent, by Joseph Conrad"],
    "Neutral": [
      "A Personal Anthology of Shakespeare, compiled by Martin Clifton"
    ]};
  CameraDescription camera;
  CameraController controller;
  bool _isInited = false;
  String _url;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final cameras = await availableCameras();
      print(cameras);
      // setState(() {});
      controller = CameraController(cameras[1], ResolutionPreset.medium);
      controller.initialize().then((value) => {
        setState(() {
          _isInited = true;
        })
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(

        child: Icon(Icons.camera),
        onPressed: () async {

          final path = join(
              (await getTemporaryDirectory()).path, '${DateTime.now()}.png');

          await controller.takePicture(path);

          await crop(path);


          var book = await getBook(path);
          print("Book: " + book.title);
          developer.log(book.toString());

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TellingV2(book:book)//DisplayPictureScreen(imagePath: path),
            ),
          );

        },
      ),
      key: scaffoldKey,
      body: SafeArea(
        child: Container(

          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height ,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [

              Container(

                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.20,
                  decoration: BoxDecoration(
                    color: Color(0x70EEEEEE),
                    image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      image: Image.asset(
                        'assets/images/original.jpg',
                      ).image,
                    ),
                    shape: BoxShape.rectangle,
                  ),
                child: Column(

                    children:  [
                      //Text("\nTry out the \n",style: TextStyle(fontSize: 15),),
                      Text("\n"),
                      Image.asset('assets/images/c874bc5649ca63dd5a11ae9ececfad05.png', fit: BoxFit.cover,height:50),
                      Container(height: 20,),
                      Text("Take a photo of your face and \nwe will choose a story for you! ",style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),maxLines: 2,overflow: TextOverflow
                          .ellipsis,),
  ]
              )),

              //Divider(),
              Expanded(
                flex: 2,
                child: Container(
                    width: double.infinity,
                    child: _isInited
                        ? ClipRect(
                      child: Container(
                        child: Transform.scale(
                          scale: controller.value.aspectRatio / MediaQuery.of(context).size.aspectRatio,
                          child: Center(
                            child: AspectRatio(
                              aspectRatio: controller.value.aspectRatio,
                              child: CameraPreview(controller),
                            ),
                          ),
                        ),
                      ),
                    )
                        : Container()
                ),
              ),
              Container(
                height: 15,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 120,
                      width: 120,
                      child: _url != null
                          ? Image.file(
                        File(_url),
                        height: 120,
                        width: 120,
                      )
                          : Container(),
                    ),
                  ],
                ),
              ),
              Container(
                height: 35,

              )
              /*
              FloatingActionButton(

                child: Icon(Icons.camera),
                onPressed: () async {

                  final path = join(
                      (await getTemporaryDirectory()).path, '${DateTime.now()}.png');

                  await controller.takePicture(path);

                  await crop(path);


                  var book = await getBook(path);
                  print("Book: " + book.title);
                  developer.log(book.toString());

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TellingV2(book:book)//DisplayPictureScreen(imagePath: path),
                    ),
                  );

                },
              ),
              */
            ],
          ),
        ),
      ),
    );
  }



  void crop(path) async {

    InputImage inputImage = new InputImage.fromFile(File(path));
    //final Size absoluteImageSize = inputImage.inputImageData.size;
    //final InputImageRotation rotation = inputImage.inputImageData.imageRotation;

    if (isBusy) return null;
    isBusy = true;
    final faces = await faceDetector.processImage(inputImage);

    Map<String,int> faceMap = faceDetectorCrop(faces)[0]; //for the moment consider 1 face
    img.Image originalImage = img.decodeImage(File(path).readAsBytesSync());

    img.Image faceCrop = img.grayscale(img.copyCrop(img.copyRotate(originalImage, -90), faceMap['x'], faceMap['y'], faceMap['w'], faceMap['h']));
    File(path).writeAsBytesSync(img.encodePng(faceCrop));

    isBusy = false;
  }



  Future classifyImage(path) async {

    /*
    final inputImage = InputImage.fromFilePath(path);
    if (isBusy) return;
    isBusy = true;
    final faces = await faceDetector.processImage(inputImage);
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      Map<String,int> faceMap = faceDetectorCrop(faces)[0]; //for the moment consider 1 face
      img.Image originalImage = img.decodeImage(File(path).readAsBytesSync());
      img.Image faceCrop = img.copyCrop(originalImage, faceMap['x'], faceMap['y'], faceMap['w'], faceMap['h']);
      File(path).writeAsBytesSync(img.encodePng(faceCrop));
    } else {

    }
    isBusy = false;
     */




    await Tflite.loadModel(model: "assets/models/model.tflite",labels: "assets/models/labels.txt");
    List output = await Tflite.runModelOnImage(
        path: path,
        imageMean: 125.0,   // defaults to 117.0
        imageStd: 170.0,  // defaults to 1.0
        numResults: 7,    // defaults to 5
        threshold: 0.40
    );


    //final snackBar = SnackBar(content: Text());
    print("tmp:" + output.toString());
    print(output.isEmpty);
    return output.isEmpty ? "Neutral" : output[0]["label"].toString();
    //ScaffoldMessenger.of(this.context).showSnackBar(snackBar);

  }

  Future<Book> getBook(path) async
  {
    var emotion = await classifyImage(path);
    final snackBar = SnackBar(content: Text(emotion.toString()));
    final String id = emotion_corrispondece[emotion][0];

    developer.log(id);
    ScaffoldMessenger.of(this.context).showSnackBar(snackBar);

    Repository rep = new Repository();

    return await rep.getBook(id);
  }

}



 */
