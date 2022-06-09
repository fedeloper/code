import 'dart:developer' as developer;
import 'dart:io';
import 'package:collection/collection.dart';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image/image.dart' as img;
import 'package:magic_mirror/magicmirror/cropper.dart';
import 'package:magic_mirror/searchstory/book.dart';
import 'package:magic_mirror/searchstory/repository.dart';
import 'package:magic_mirror/tellingthestory/tellingv2.dart';





class MagicMirror3Widget extends StatefulWidget {

  const MagicMirror3Widget({
    super.key,
    required this.camera,
});

  final CameraDescription camera;



  @override
  MagicMirror3WidgetState createState() => MagicMirror3WidgetState();
}

class MagicMirror3WidgetState extends State<MagicMirror3Widget> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late String _url = "https://www.shutterstock.com/image-vector/enchanted-mirror-icon-trendy-logo-concept-1262424862";
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isInited = false;
  bool isBusy = false;





  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final cameras = await availableCameras();
      print(cameras);

      //final size = MediaQuery.of(context).size;
      //final deviceRatio = size.width / size.height;

      // To display the current output of the camera,
      // create a CameraController


      _controller = CameraController(
        // Get a specific camera from the list of available cameras
          cameras[1], //Should be the "selfie" one
          // Define the resolution to use
          ResolutionPreset.high,
      );

      // Next, initialize the controller. This returns a Future
      _initializeControllerFuture = _controller.initialize().then((value) =>
      {
        setState(() {
          _isInited = true;
        })
      });
    });
  }

    @override
    void dispose() {
      // Dispose of the controller when the widget is disposed
      _controller.dispose();

      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      var size = MediaQuery.of(context).size;
      final deviceRatio = 1;
      final screenH = max(size.width, size.height);
      final screenW = max(size.width, size.height);
      size = _controller.value.previewSize!;
      final previewH = max(size.height, size.width);
      final previewW = max(size.height, size.width);
      final screenRatio = screenH / screenW;
      final previewRatio = previewH / previewW;

      return Scaffold(
        key: scaffoldKey,
        body: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height *0.2,
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
                    children: [
                      Text("\n"),
                      Image.asset('assets/images/c874bc5649ca63dd5a11ae9ececfad05.png', fit: BoxFit.cover,height:50),
                      Container(height: 20,),
                      Text("Take a photo of your face and \nwe will choose a story for you! ",style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),maxLines: 2,overflow: TextOverflow
                          .ellipsis,),
                    ],
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: Container(
                      width: double.infinity,
                      child: _isInited ? ClipRect(
                        child: OverflowBox(
                          maxHeight:  screenRatio > previewRatio ? screenH : screenW / previewW * previewH,
                          maxWidth: screenRatio > previewRatio? screenH / previewH * previewW : screenW,
                                child: CameraPreview(_controller),
                        ) ,
                      ) : Container(),
                    ),
                ),
                Container(
                  height: 35,
                )
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.camera),
          onPressed: () async {
            // Take the picture in a try/catch block. If anything goes wrong,
            // catch the error
            try{
              // Ensure the camera is initialized
              await _initializeControllerFuture;

              // Attempt to take a picture and get the file 'image' (XFile)
              // where it was saved.
              // Can access to its path via `image.path`
              final image = await _controller.takePicture();

              final path = image.path;



              var book = await getBook(path);
              print("Book: " + book.title);
              developer.log(book.toString());


              // If the picture was taken, display it on a new screen.
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TellingV2(book: book)
                ),
              );
            } catch (e) {
              // If an error occurs, log it to the console
              print(e);
            }
          },
        ),
      );
    }

  /*Future<void> crop(path) async {

    InputImage inputImage = new InputImage.fromFile(File(path));
    //final Size absoluteImageSize = inputImage.inputImageData.size;
    //final InputImageRotation rotation = inputImage.inputImageData.imageRotation;

    if (isBusy) return null;
    isBusy = true;
    final faces = await faceDetector.processImage(inputImage);

    Map<String,int> faceMap = faceDetectorCrop(faces)[0]; //for the moment consider 1 face
    img.Image? originalImage = img.decodeImage(File(path).readAsBytesSync());

    img.Image faceCrop = img.grayscale(img.copyCrop(img.copyRotate(originalImage!, -90), faceMap['x']!, faceMap['y']!, faceMap['w']!, faceMap['h']!));
    File(path).writeAsBytesSync(img.encodePng(faceCrop));

    isBusy = false;

  }*/
  String detectSmile(smileProb) {
    if (smileProb > 0.86) {

      return 'Big smile with teeth';
    } else if (smileProb > 0.8) {

      return 'Big Smile';
    } else if (smileProb > 0.3) {

      return 'Smile';
    } else {

      return 'Sad';
    }
  }
  FaceDetector? _faceDetector;
  Future<Book> getBook(path) async
  {
    _faceDetector = GoogleMlKit.vision.faceDetector(
      FaceDetectorOptions(
        enableClassification: true,
        enableLandmarks: true,
      ),
    );
    InputImage inputImage = new InputImage.fromFile(File(path));
    List<Face> l= await _faceDetector!.processImage(inputImage) ;
    if (l.length>0){
      var emotion = detectSmile(l[0].smilingProbability);
      final snackBar = SnackBar(content: Text(emotion.toString()));
      final String id = emotion_correspondance[emotion]![0];

      developer.log(id);
      ScaffoldMessenger.of(this.context).showSnackBar(snackBar);

      Repository rep = new Repository();

      return await rep.getBook(id);

    }
    developer.log("ERRORE");
    Repository rep = new Repository();
    return await rep.getBook("The Man Who Knew Too Much");
  }

  static const Map<String, List<String>> emotion_correspondance =
  {"Big smile with teeth": ["The Man Who Knew Too Much"],
    "Disgust": ["Dr. Nikola’s Experiment"],
    "Fear": ["Has a Frog a Soul"],
    "Smile": ["Christmas Carol Collection 2009"],
    "Sad": ["Ghost Stories of an Antiquary"],
    "Big Smile": ["The Secret Agent, by Joseph Conrad"],
    "Neutral": [
      "A Personal Anthology of Shakespeare, compiled by Martin Clifton"
    ]};





  MapEntry<String, double> getTopProbability(Map<String, double> doubleMap) {
    var pq = PriorityQueue<MapEntry<String, double>>(compare);
    pq.addAll(doubleMap.entries);

    return pq.first;
  }

  int compare(MapEntry<String, double> e1, MapEntry<String, double> e2) {
    if (e1.value > e2.value) {
      return -1;
    } else if (e1.value == e2.value) {
      return 0;
    } else {
      return 1;
    }
  }



}

