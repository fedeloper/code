import 'dart:async';
import 'dart:io';
import 'package:flash/flash.dart';
import 'package:magic_mirror/accountpage/accountpage_widget.dart';
import 'package:magic_mirror/home_page/home_page_widget.dart';
import 'package:magic_mirror/searchstory/searchstory_widget.dart';
import 'package:path/path.dart';
import 'package:animate_icons/animate_icons.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:just_audio/just_audio.dart';
import 'package:magic_mirror/searchstory/audiofile.dart';
import 'package:magic_mirror/searchstory/book.dart';
import 'package:magic_mirror/searchstory/repository.dart';
import 'package:path_provider/path_provider.dart';
import 'common.dart';
import 'dart:developer' as developer;
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:rxdart/rxdart.dart';
import '../components/mado_widget.dart';

void main() => runApp(MaterialApp(home: TellingV2()));

class TellingV2 extends StatefulWidget {
  final Book book;
  TellingV2({Key key, this.book}) : super(key: key);

  @override
  _TellingV2State createState() => _TellingV2State(this.book);
}

class _TellingV2State extends State<TellingV2> {
  AnimateIconController controller_icon;
  Timer timer;
  final Book book;
  AudioPlayer _player;
  ConcatenatingAudioSource _playlist;
  int _addedCount = 0;
  CameraDescription camera;
  CameraController controller;
  bool attention_ai = true;
  bool secure_ai = true;
  bool _isInited = false;
  FaceDetector faceDetector =
      GoogleMlKit.vision.faceDetector(FaceDetectorOptions(
    enableContours: true,
    enableClassification: true,
  ));

  _TellingV2State(this.book);
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
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => checkEyes());
    _player = AudioPlayer();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));

    _init();
  }

  Future<void> checkEyes() async {
    if (_player.playing & (attention_ai | secure_ai)) {
      final path =
          join((await getTemporaryDirectory()).path, '${DateTime.now()}.png');

      await controller.takePicture(path);
      InputImage inputImage = new InputImage.fromFile(File(path));
      final faces = await faceDetector.processImage(inputImage);
      if ((faces.length == 0) & (attention_ai == true)) {
        _player.stop();
        showAlertDialog_attention(this.context);
      }
      if ((faces.length > 1) & (secure_ai == true)) {
        loaded_links = false;
        _player.stop();
        showAlertDialog_secure(this.context);
      }
    }
  }

  bool loaded_links = false;
  Future<void> _init() async {
    Repository rep = new Repository();
    List<AudioFile> files = await rep.fetchAudioFiles(book.id);
    developer.log(files[0].title.toString());
    var v = files
        .map((x) => AudioSource.uri(
              Uri.parse(x.url),
              tag: AudioMetadata(
                album: book.title,
                title: x.title,
                artwork: "https://archive.org/download/" +
                    book.id +
                    '/__ia_thumb.jpg',
              ),
            ))
        .toList();
    _playlist = ConcatenatingAudioSource(children: v);

    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    // Listen to errors during playback
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    try {
      await _player.setAudioSource(_playlist);
    } catch (e) {
      // Catch load errors: 404, invalid url...
      print("Error loading audio source: $e");
    }
    this.setState(() {
      loaded_links = true;
    });
  }
  int _selectedIndex = 0;
  @override
  void dispose() {
    faceDetector.close();
    _player.dispose();
    super.dispose();
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    controller_icon = AnimateIconController();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          flexibleSpace: Image(
            image: AssetImage('assets/images/original.jpg'),
            fit: BoxFit.cover,
          ),
          backgroundColor: Colors.transparent,
          title:Image.asset('assets/images/c874bc5649ca63dd5a11ae9ececfad05.png', fit: BoxFit.cover,height:30),

          actions: <Widget>[
            IconButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        controller.dispose();
                        dispose();
                        return HomePageWidget();
                      }
                    ),
                  );
                },
                icon: Icon(Icons.home))
          ],
        ),
        body: SafeArea(
          child: !loaded_links
              ? Center(
                  child: SpinKitFoldingCube(color: Colors.blue, size: 50.0))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /*
                    Container(
                      height: 50,
                      color: Colors.white,
                    ),

                     */

                    /*
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.25,
                      decoration: BoxDecoration(
                        color: Color(0xFFEEEEEE),
                      ),
                      child: MadoWidget(),
                    ),
                    */
                    Expanded(
                      child: StreamBuilder<SequenceState>(
                        stream: _player.sequenceStateStream,
                        builder: (context, snapshot) {
                          final state = snapshot.data;
                          if (state?.sequence.isEmpty ?? true)
                            return SizedBox();
                          final metadata =
                              state.currentSource.tag as AudioMetadata;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                      child: Image.network(metadata.artwork)),
                                ),
                              ),
                              Text(metadata.album,
                                  style: Theme.of(context).textTheme.headline6),
                              Text(metadata.title),
                            ],
                          );
                        },
                      ),
                    ),
                    ControlButtons(_player),
                    StreamBuilder<PositionData>(
                      stream: _positionDataStream,
                      builder: (context, snapshot) {
                        final positionData = snapshot.data;
                        return SeekBar(
                          duration: positionData?.duration ?? Duration.zero,
                          position: positionData?.position ?? Duration.zero,
                          bufferedPosition:
                              positionData?.bufferedPosition ?? Duration.zero,
                          onChangeEnd: (newPosition) {
                            _player.seek(newPosition);
                          },
                        );
                      },
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        StreamBuilder<LoopMode>(
                          stream: _player.loopModeStream,
                          builder: (context, snapshot) {
                            final loopMode = snapshot.data ?? LoopMode.off;
                            const icons = [
                              Icon(Icons.repeat, color: Colors.grey),
                              Icon(Icons.repeat, color: Colors.orange),
                              Icon(Icons.repeat_one, color: Colors.orange),
                            ];
                            const cycleModes = [
                              LoopMode.off,
                              LoopMode.all,
                              LoopMode.one,
                            ];
                            final index = cycleModes.indexOf(loopMode);
                            return IconButton(
                              icon: icons[index],
                              onPressed: () {
                                _player.setLoopMode(cycleModes[
                                    (cycleModes.indexOf(loopMode) + 1) %
                                        cycleModes.length]);
                              },
                            );
                          },
                        ),
                        Expanded(
                          child: Text(
                            "Playlist",
                            style: Theme.of(context).textTheme.headline6,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        StreamBuilder<bool>(
                          stream: _player.shuffleModeEnabledStream,
                          builder: (context, snapshot) {
                            final shuffleModeEnabled = snapshot.data ?? false;
                            return IconButton(
                              icon: shuffleModeEnabled
                                  ? Icon(Icons.shuffle, color: Colors.orange)
                                  : Icon(Icons.shuffle, color: Colors.grey),
                              onPressed: () async {
                                final enable = !shuffleModeEnabled;
                                if (enable) {
                                  await _player.shuffle();
                                }
                                await _player.setShuffleModeEnabled(enable);
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    Container(
                      height: 150.0,
                      child: StreamBuilder<SequenceState>(
                        stream: _player.sequenceStateStream,
                        builder: (context, snapshot) {
                          final state = snapshot.data;
                          final sequence = state?.sequence ?? [];
                          return ReorderableListView(
                            onReorder: (int oldIndex, int newIndex) {
                              if (oldIndex < newIndex) newIndex--;
                              _playlist.move(oldIndex, newIndex);
                            },
                            children: [
                              for (var i = 0; i < sequence.length; i++)
                                Dismissible(
                                  key: ValueKey(sequence[i]),
                                  background: Container(
                                    color: Colors.redAccent,
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Icon(Icons.delete,
                                          color: Colors.white),
                                    ),
                                  ),
                                  onDismissed: (dismissDirection) {
                                    _playlist.removeAt(i);
                                  },
                                  child: Material(
                                    color: i == state.currentIndex
                                        ? Colors.grey.shade300
                                        : null,
                                    child: ListTile(
                                      title:
                                          Text(sequence[i].tag.title as String),
                                      onTap: () {
                                        _player.seek(Duration.zero, index: i);
                                      },
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                    Divider(),
                    Container(
                      height: 60,
                        child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Spacer(),
                        Container(
                            padding: EdgeInsets.fromLTRB(20, 0, 35, 0),
                            child: AnimateIcons(
                              startIcon: Icons.visibility,
                              endIcon: Icons.hearing, //visibility_off,
                              size: 50.0,
                              controller: controller_icon,
                              // add this tooltip for the start icon
                              startTooltip: 'Attention Mode',
                              // add this tooltip for the end icon
                              endTooltip: 'Relax Mode',

                              onStartIconPress: () {
                                attention_ai = false;
                                controller.dispose();
                                _showBasicsFlash(Duration(milliseconds: 1300),
                                    "Relax Mode: activated");

                                return true;
                              },
                              onEndIconPress: () {
                                attention_ai = true;
                                //controller.initialize();
                                _showBasicsFlash(Duration(milliseconds: 1300),
                                    "Attention Mode : activated");
                                return true;
                              },

                              duration: Duration(milliseconds: 500),
                              startIconColor: Colors.blueAccent,
                              endIconColor: Colors.blueAccent,
                              clockwise: true,
                            )),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.fromLTRB(35, 0, 75, 0),
                          child: AnimateIcons(
                            startIcon: Icons.person,
                            endIcon: Icons.groups,
                            size: 50.0,
                            controller: controller_icon,
                            // add this tooltip for the start icon
                            startTooltip: 'Single Mode',
                            // add this tooltip for the end icon
                            endTooltip: 'Group Mode',

                            onStartIconPress: () {
                              secure_ai = false;
                              _showBasicsFlash(Duration(milliseconds: 1300),
                                  "Group Mode: activated");

                              return true;
                            },
                            onEndIconPress: () {
                              secure_ai = true;
                              _showBasicsFlash(Duration(milliseconds: 1300),
                                  "Single Mode: activated");
                              return true;
                            },
                            duration: Duration(milliseconds: 500),
                            startIconColor: Colors.blueAccent,
                            endIconColor: Colors.blueAccent,
                            clockwise: true,
                          ),
                        )
                      ],
                    )),
                  ],
                ),
        ),
      ),
    );
  }

  void _showBasicsFlash(Duration duration, String text) {
    showFlash(
      context: this.context,
      duration: duration,
      builder: (context, controller) {
        return Flash(
          controller: controller,
          behavior: FlashBehavior.floating,
          position: FlashPosition.bottom,
          boxShadows: kElevationToShadow[4],
          horizontalDismissDirection: HorizontalDismissDirection.horizontal,
          child: FlashBar(
            content: Text(text),
          ),
        );
      },
    );
  }

  showAlertDialog_secure(BuildContext context) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("Resume listening"),
      onPressed: () {
        loaded_links = true;

        _player.play();
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Privacy protection"),
      content: Text(
          "We detected 2 people watching the screen, to avoid an intruder know what are you listening we have obscured the app and stopped the listening. Tip: to deactive this feature tap on the right bottom lock"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      barrierColor: Colors.black,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialog_attention(BuildContext context) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("Resume listening"),
      onPressed: () {
        _player.play();
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Not watching the screen"),
      content: Text(
          "We noticed that you are not watching the screen and we paused the player. Tip: if you want the deactivate this function tap on the bottom-central eye."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  ControlButtons(this.player);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.volume_up),
          onPressed: () {
            showSliderDialog(
              context: context,
              title: "Adjust volume",
              divisions: 10,
              min: 0.0,
              max: 1.0,
              stream: player.volumeStream,
              onChanged: player.setVolume,
            );
          },
        ),
        StreamBuilder<SequenceState>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: Icon(Icons.skip_previous),
            onPressed: player.hasPrevious ? player.seekToPrevious : null,
          ),
        ),
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: EdgeInsets.all(8.0),
                width: 64.0,
                height: 64.0,
                child: CircularProgressIndicator(),
              );
            } else if (playing != true) {
              return IconButton(
                icon: Icon(Icons.play_arrow),
                iconSize: 64.0,
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: Icon(Icons.pause),
                iconSize: 64.0,
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                icon: Icon(Icons.replay),
                iconSize: 64.0,
                onPressed: () => player.seek(Duration.zero,
                    index: player.effectiveIndices.first),
              );
            }
          },
        ),
        StreamBuilder<SequenceState>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: Icon(Icons.skip_next),
            onPressed: player.hasNext ? player.seekToNext : null,
          ),
        ),
        StreamBuilder<double>(
          stream: player.speedStream,
          builder: (context, snapshot) => IconButton(
            icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {
              showSliderDialog(
                context: context,
                title: "Adjust speed",
                divisions: 10,
                min: 0.5,
                max: 1.5,
                stream: player.speedStream,
                onChanged: player.setSpeed,
              );
            },
          ),
        ),
      ],
    );
  }
}

class AudioMetadata {
  final String album;
  final String title;
  final String artwork;

  AudioMetadata({
    this.album,
    this.title,
    this.artwork,
  });
}
