import '../components/mado_widget.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_video_player.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import '../magicmirror/magicmirror_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import '../components/mado_widget.dart';
import '../tellingthestory/tellingthestory_widget.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import '../magicmirror/magicmirror_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tflite/tflite.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:developer';


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
                            builder: (context) => MagicmirrorWidget(),
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
  Future classifyImage() async {

    await Tflite.loadModel(model: "assets/models/model.tflite",labels: "assets/models/labels.txt");
    var output = await Tflite.runModelOnImage(path: path);

    final snackBar = SnackBar(content: Text(output.toString()));

    ScaffoldMessenger.of(this.context).showSnackBar(snackBar);

  }
}