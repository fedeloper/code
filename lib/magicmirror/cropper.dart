//import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

//import 'coordinates_translator.dart';


List<Map<String, int>> faceDetectorCrop(List<Face> faces) {
  List<Map<String, int>> faceMaps = [];
  for (Face face in faces) {
    int x = face.boundingBox.left.toInt();
    int y = face.boundingBox.top.toInt();
    int w = face.boundingBox.width.toInt();
    int h = face.boundingBox.height.toInt();
    Map<String, int> thisMap = {'x': x, 'y': y, 'w': w, 'h':h};
    faceMaps.add(thisMap);
  }

  return faceMaps;
}