import 'dart:developer' as developer;
import 'dart:io';
import 'package:collection/collection.dart';
import 'dart:math';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
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



  final FaceDetector faceDetector = FaceDetector(options: FaceDetectorOptions(
    enableContours: true,
  ));


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
          cameras.last, //Should be the "selfie" one
          // Define the resolution to use
          ResolutionPreset.high);

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
      faceDetector.close();
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

              await crop(path);

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

  Future<void> crop(path) async {

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

  }

  Future<Book> getBook(path) async
  {
    var emotion = await classifyImage(path);
    final snackBar = SnackBar(content: Text(emotion.toString()));
    final String id = emotion_correspondance[emotion]![0];

    developer.log(id);
    ScaffoldMessenger.of(this.context).showSnackBar(snackBar);

    Repository rep = new Repository();

    return await rep.getBook(id);
  }

  static const Map<String, List<String>> emotion_correspondance =
  {"Angry": ["The Man Who Knew Too Much"],
    "Disgust": ["Dr. Nikola’s Experiment"],
    "Fear": ["Has a Frog a Soul"],
    "Happy": ["Christmas Carol Collection 2009"],
    "Sad": ["Ghost Stories of an Antiquary"],
    "Surprise": ["The Secret Agent, by Joseph Conrad"],
    "Neutral": [
      "A Personal Anthology of Shakespeare, compiled by Martin Clifton"
    ]};




  Future classifyImage(path) async {

    //Create an ImageProgessor with all ops required.
    ImageProcessor imageProcessor = ImageProcessorBuilder().add(
      NormalizeOp(125.0, 170.0)
    ).build();

    // Create a TensorImage from a File
    TensorImage tensorImage = TensorImage.fromFile(File(path));

    // Preprocess the image
    tensorImage = imageProcessor.process(tensorImage);

    // Create a container for the result and specify that this is a flaot model.
    TensorBuffer probabilityBuffer = TensorBuffer.createFixedSize(<int>[1,7], TfLiteType.float32);


    try {
      // Create Interpreter from asset.
      Interpreter interpreter = await Interpreter.fromAsset("assets/models/model.tflite");
      interpreter.run(tensorImage.buffer, probabilityBuffer.buffer);
    } catch (e) {
      print('Error loading model: ' + e.toString());
    }

    List<String> labels = await FileUtil.loadLabels("assets/models/labels.txt");

    // Associate the probabilities with category labels

    //TensorProcessor probabilityProcessor = TensorProcessorBuilder().add(postProcessNormalizeOp).build();
    TensorLabel tensorLabel = TensorLabel.fromList(labels, probabilityBuffer);

    Map<String, double> doubleMap = tensorLabel.getMapWithFloatValue();

    // Get the top predition
    final output = getTopProbability(doubleMap);

    //final snackBar = SnackBar(content: Text());
    print("tmp:" + output.toString());
    print(output.key.isEmpty);
    return output.key.isEmpty ? "Neutral" : output.key[0];
    //ScaffoldMessenger.of(this.context).showSnackBar(snackBar);

  }

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

