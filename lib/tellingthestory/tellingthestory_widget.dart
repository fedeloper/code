/*
// @dart=2.9
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:collection/collection.dart';

import '../components/mado_widget.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import '../magicmirror/magicmirror3_widget.dart';


class TellingthestoryWidget extends StatefulWidget {
  final String path;
  TellingthestoryWidget({Key key,this.path}) : super(key: key);

  @override
  _TellingthestoryWidgetState createState() => _TellingthestoryWidgetState(this.path);
}

class _TellingthestoryWidgetState  extends State<TellingthestoryWidget> {
  CameraDescription camera;
  CameraController controller;
  bool _isInited = false;
  _TellingthestoryWidgetState(this.path);
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {

      classifyImage();

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
      key: scaffoldKey,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.25,
              decoration: BoxDecoration(
                color: Color(0xFFEEEEEE),
              ),
              child: MadoWidget(),
            ),
            Container(
              height: MediaQuery.of(context).size.height*0.6 ,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                        width: 100,
                        height:150,
                        child: _isInited
                            ?  ClipRect(
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
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: FFButtonWidget(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MagicMirror3Widget(camera: camera),
                          ),
                        );
                      },
                      text: 'Re-Magic',
                      options: FFButtonOptions(
                        width: 130,
                        height: 40,
                        color: FlutterFlowTheme.primaryColor,
                        textStyle: FlutterFlowTheme.subtitle2.override(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                        ),
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1,
                        ),
                        borderRadius: 12,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment(-0.11, -0.19),
                    child: Text(
                      'Story telling',
                      style: FlutterFlowTheme.bodyText1.override(
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment(-0.81, -0.94),
                    child: Text(
                      'title',
                      style: FlutterFlowTheme.title1.override(
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment(-0.72, -0.82),
                    child: Text(
                      'capther',
                      style: FlutterFlowTheme.bodyText1.override(
                        fontFamily: 'Poppins',
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );


  }
  String result;
  String path;


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
 */

