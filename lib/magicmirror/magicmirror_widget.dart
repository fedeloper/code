/*
import 'dart:developer' as developer;
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:magic_mirror/searchstory/book.dart';
import 'package:magic_mirror/searchstory/repository.dart';
import 'package:magic_mirror/tellingthestory/tellingv2.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';


import '../components/mado_widget.dart';
class MagicmirrorWidget extends StatefulWidget {
  @override
  _MagicmirrorWidget createState() => _MagicmirrorWidget();
}
final scaffoldKey = GlobalKey<ScaffoldState>();

class _MagicmirrorWidget extends State<MagicmirrorWidget> {
  Map<String, List<String>> emotion_corrispondece=
  {"Angry":["The Man Who Knew Too Much"],
    "Disgust":["Dr. Nikola’s Experiment"],
    "Fear":["Has a Frog a Soul"],
   "Happy":["Christmas Carol Collection 2009"],
    "Sad":["Ghost Stories of an Antiquary"],
    "Surprise":["The Secret Agent, by Joseph Conrad"],
    "Neutral":["A Personal Anthology of Shakespeare, compiled by Martin Clifton"]};
  CameraDescription camera;
  CameraController controller;
  bool _isInited = false;
  String _url;

  @override
  void initState() {
    // TODO: implement initState
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
  Future classifyImage(path) async {

    await Tflite.loadModel(model: "assets/models/model.tflite",labels: "assets/models/labels.txt");
    var output = await Tflite.runModelOnImage(path: path);

    //final snackBar = SnackBar(content: Text());
    return output[0]["label"].toString();
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        body: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 1,
            decoration: BoxDecoration(
              color: Color(0xFFEEEEEE),
              image: DecorationImage(
                fit: BoxFit.fill,
                image: Image.network(
                  '',
                ).image,
              ),
              shape: BoxShape.rectangle,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.25,
                  decoration: BoxDecoration(
                    color: Color(0x52EEEEEE),
                  ),
                  child: MadoWidget(),
                ),
                Divider(),
                Expanded(
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
                Divider(),
                 FloatingActionButton(
                  child: Icon(Icons.camera),
                  onPressed: () async {


                    final path = join(
                        (await getTemporaryDirectory()).path, '${DateTime.now()}.png');

                    await controller.takePicture(path);
                    var book = await getBook(path);
                    developer.log(book.toString());

                    Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => TellingV2(book:book),
                    ),
                    );

                  },
                ),

              ],
            ),
          ),
        ),
      );


  }
}
 */

