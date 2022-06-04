import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:magic_mirror/accountpage/accountpage_widget.dart';
import 'package:magic_mirror/searchstory/book.dart';
import 'package:magic_mirror/searchstory/repository.dart';
import 'package:magic_mirror/searchstory/searchstory_widget.dart';
import 'package:magic_mirror/tellingthestory/tellingv2.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:developer';
import '../components/mado_widget.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../magicmirror/magicmirror2_widget.dart';
import 'package:alan_voice/alan_voice.dart';
class placeHolder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              'Page under construction!',
              style: TextStyle(color: Colors.black),
            ),
          ),
          Container(
            height: 15,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Icon(
              Icons.construction,
            ),
          ),
        ]),
      ),
    );
  }
}

class ImageTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final ImageProvider image;
  final double imageHeight;
  final double radius;
  final Widget text;

  ImageTextButton({
    @required this.onPressed,
    @required this.image,
    this.imageHeight = 120,
    this.radius = 150,
    @required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 2),
            Ink.image(
              image: image,
              height: imageHeight,
              width: 130,
              fit: BoxFit.fill,
            ),
            SizedBox(height: 2),
          ],
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}
List<Book> books = [];
class HomeState extends State<Home> {
  final pageViewController = PageController();
  final scaffoldKey = GlobalKey<ScaffoldState>();


  void tt() async {
    Repository rep = new Repository();

    //this.books= ;
    List<Book> bs = await rep.topBooks(3);

    addItemToList(bs);
    // list.forEach((Book b) {  addItemToList(b);});
  }

  void addItemToList(List<Book> list) {
    setState(() {
      books = list;
    });
  }

  @override
  Widget build(BuildContext context) {



    tt();
    return Scaffold(
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
              child: Container(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                      height: MediaQuery.of(context).size.height - 50,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.25,
                          decoration: BoxDecoration(
                            color: Color(0x52EEEEEE),
                          ),
                          child: MadoWidget(),
                        ),

                        Container(
                          height: 300,
                          width: double.infinity,
                          child: Stack(
                            children: [
                              books.isEmpty
                                  ? Center(
                                      child: SpinKitFoldingCube(
                                          color: Colors.blue, size: 50.0))
                                  : PageView.builder(
                                      controller: pageViewController,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: books.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return InkWell(
                                          child: Container(
                                            height: 500,
                                            child: Card(
                                              margin: EdgeInsets.all(4.0),
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              color: Color(0xFFF5F5F5),
                                              elevation: 3,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Image.network(
                                                    "https://archive.org/download/" +
                                                        books[index].id +
                                                        '/__ia_thumb.jpg',
                                                    width: double.infinity,
                                                    height: 120,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            15, 15, 15, 25),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            "Suggested Story #" +
                                                                (index + 1)
                                                                    .toString(),
                                                            //style: GoogleFonts.cutiveMono(fontSize: 25, fontWeight: FontWeight.bold),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  0, 10, 0, 0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                (() {
                                                                  if (books[index]
                                                                          .title
                                                                          .length >
                                                                      30) {
                                                                    return books[index]
                                                                            .title
                                                                            .substring(0,
                                                                                30) +
                                                                        "...";
                                                                  }
                                                                  return books[
                                                                          index]
                                                                      .title;
                                                                }()),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: FlutterFlowTheme
                                                                    .bodyText1
                                                                    .override(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                              Text(
                                                                books[index]
                                                                    .author,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: FlutterFlowTheme
                                                                    .bodyText1
                                                                    .override(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  color: FlutterFlowTheme
                                                                      .secondaryColor,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  0, 8, 0, 0),
                                                          child: Text(
                                                            books[index]
                                                                .description,
                                                            overflow:
                                                                TextOverflow
                                                                    .fade,
                                                            maxLines: 3,
                                                            style:
                                                                FlutterFlowTheme
                                                                    .bodyText1
                                                                    .override(
                                                              fontFamily:
                                                                  'Poppins',
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          onTap: () async {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => TellingV2(
                                                    book: books[index]),
                                              ),
                                            );
                                          },
                                        );
                                      }),
                              Align(
                                alignment: Alignment(0, 0.95),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  child: SmoothPageIndicator(
                                    controller: pageViewController,
                                    count: 3,
                                    axisDirection: Axis.horizontal,
                                    onDotClicked: (i) {
                                      pageViewController.animateToPage(
                                        i,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.ease,
                                      );
                                    },
                                    effect: ExpandingDotsEffect(
                                      expansionFactor: 2,
                                      spacing: 8,
                                      radius: 16,
                                      dotWidth: 16,
                                      dotHeight: 16,
                                      dotColor: Color(0xFF9E9E9E),
                                      activeDotColor: Color(0xFF3F51B5),
                                      paintStyle: PaintingStyle.fill,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Card(
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const ListTile(
                                leading: Icon(Icons.face),
                                title: Text('Magic Mirror'),
                                subtitle: Text('Let the Mirror choose a story for you!'),
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/pink-magic-mirror-cartoon-wonderful-64577704.jpg',
                                    width: 100,//MediaQuery.of(context).size.width * 0.6,
                                    height: 110,
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  TextButton(
                                    child: const Text('Try it!'),
                                    onPressed: () async {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(

                                          builder: (context) =>
                                              MagicMirror2Widget(),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  TextButton(
                                    child: const Text('Info'),
                                    onPressed: () => showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) => AlertDialog(

                                        title: const Text('Magic Mirror Usage'),
                                        content: Text(
                                            "\n                   Face the Mirror\n\n                     Take a selfie\n\n                   Enjoy the story!"),
                                        contentTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, 'Got it!'),
                                            child: const Text('Got it!'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                              ),
                            ],
                          ),

                        ),

                        /*
                        InkWell(
                          child: Container(
                            height: 260,
                            child: Card(
                              margin: EdgeInsets.all(4.0),
                              clipBehavior:
                              Clip.antiAliasWithSaveLayer,
                              color: Color(0xFFF5F5F5),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(20),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [

                                  Image.network(
                                    'https://thumbs.dreamstime.com/b/pink-magic-mirror-cartoon-wonderful-64577704.jpg',
                                    width: double.infinity,
                                    height: 120,
                                    fit: BoxFit.contain,
                                  ),

                                  Padding(
                                    padding:
                                    EdgeInsets.fromLTRB(
                                        15, 15, 15, 25),
                                    child: Column(
                                      mainAxisSize:
                                      MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets
                                              .fromLTRB(
                                              0, 10, 0, 0),
                                          child: Row(
                                            mainAxisSize:
                                            MainAxisSize
                                                .max,
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              Text("Let's try the Magic Mirror"
                                              ),
                                              Text(
                                                "Face Emotion",
                                                overflow:
                                                TextOverflow
                                                    .ellipsis,
                                                style: FlutterFlowTheme
                                                    .bodyText1
                                                    .override(
                                                  fontFamily:
                                                  'Poppins',
                                                  color: FlutterFlowTheme
                                                      .secondaryColor,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets
                                              .fromLTRB(
                                              0, 8, 0, 0),
                                          child: Text(
                                            "let the MagicMirror choose a story for you! Tap here to try it.",
                                            overflow:
                                            TextOverflow
                                                .fade,
                                            maxLines: 3,
                                            style:
                                            FlutterFlowTheme
                                                .bodyText1
                                                .override(
                                              fontFamily:
                                              'Poppins',
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(

                                builder: (context) =>
                                    MagicMirror2Widget(),
                              ),
                            );
                          },
                        ),
                        */




                        /*
                    Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          color: Color(0xFFF5F5F5),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment(0, 0),
                                child: Image.network(
                                  'https://thumbs.dreamstime.com/b/pink-magic-mirror-cartoon-wonderful-64577704.jpg',
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  fit: BoxFit.fitHeight,
                                ),
                              )
                            ],
                          ),
                        ),*/
                      ],
                    ),
                  ),
                ),
              ))),
    );
  }
}

class HomePageWidget extends StatefulWidget {
  HomePageWidget({Key key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  int _selectedIndex = 1;
  static List<Widget> _widgetOptions = <Widget>[
    placeHolder(),
    Home(),
    placeHolder(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  /*
  final pageViewController = PageController();

  List<Book> books = [];

  void tt() async {
    Repository rep = new Repository();

    //this.books= ;
    List<Book> bs = await rep.topBooks(3);

    addItemToList(bs);
    // list.forEach((Book b) {  addItemToList(b);});
  }

  void addItemToList(List<Book> list) {
    setState(() {
      this.books = list;
    });
  }

   */

  @override
  Widget build(BuildContext context) {
    //tt();
    /// Init Alan Button with project key from Alan Studio
    AlanVoice.addButton("1b36d6d7bdb933e3b3117baff91b644c2e956eca572e1d8b807a3e2338fdd0dc/stage");
    AlanVoice.setLogLevel("all");
    /// Handle commands from Alan Studio
    AlanVoice.onCommand.add((command) {

      log("got new command ${command.toString()}");
      switch (command.data["command"]) {
        case "play":
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TellingV2(
                  book: books[0]),
            ),
          );
          break;
        default:
          debugPrint("Unknown command: ${command}");
      }

    });
    return Scaffold(
        key: scaffoldKey,
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: "Settings")
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[700],
          onTap: (index) {
            List lst = [
              SearchstoryWidget(),
              HomePageWidget(),
              AccountpageWidget()
            ];

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => lst[index],
              ),
            );
          },
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        )
        /*
        SafeArea(
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
                child: Container(
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints.tightFor(
                        height: MediaQuery.of(context).size.height - 50,
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
                              child: Stack(
                                children: [
                                  books.isEmpty
                                      ? Center(
                                          child: SpinKitFoldingCube(
                                              color: Colors.blue, size: 50.0))
                                      : PageView.builder(
                                          controller: pageViewController,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: books.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return InkWell(
                                              child: Card(
                                                clipBehavior:
                                                    Clip.antiAliasWithSaveLayer,
                                                color: Color(0xFFF5F5F5),
                                                elevation: 3,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Image.network(
                                                      "https://archive.org/download/" +
                                                          books[index].id +
                                                          '/__ia_thumb.jpg',
                                                      width: double.infinity,
                                                      height: 120,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              15, 15, 15, 25),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .fromLTRB(0, 10,
                                                                    0, 0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  (() {
                                                                    if (books[index]
                                                                            .title
                                                                            .length >
                                                                        30) {
                                                                      return books[index].title.substring(
                                                                              0,
                                                                              30) +
                                                                          "...";
                                                                    }
                                                                    return books[
                                                                            index]
                                                                        .title;
                                                                  }()),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: FlutterFlowTheme
                                                                      .bodyText1
                                                                      .override(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  books[index]
                                                                      .author,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: FlutterFlowTheme
                                                                      .bodyText1
                                                                      .override(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    color: FlutterFlowTheme
                                                                        .secondaryColor,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                    0, 8, 0, 0),
                                                            child: Text(
                                                              books[index]
                                                                  .description,
                                                              overflow:
                                                                  TextOverflow
                                                                      .fade,
                                                              maxLines: 4,
                                                              style:
                                                                  FlutterFlowTheme
                                                                      .bodyText1
                                                                      .override(
                                                                fontFamily:
                                                                    'Poppins',
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              onTap: () async {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        TellingV2(
                                                            book: books[index]),
                                                  ),
                                                );
                                              },
                                            );
                                          }),
                                  Align(
                                    alignment: Alignment(0, 0.95),
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                      child: SmoothPageIndicator(
                                        controller: pageViewController,
                                        count: 3,
                                        axisDirection: Axis.horizontal,
                                        onDotClicked: (i) {
                                          pageViewController.animateToPage(
                                            i,
                                            duration:
                                                Duration(milliseconds: 500),
                                            curve: Curves.ease,
                                          );
                                        },
                                        effect: ExpandingDotsEffect(
                                          expansionFactor: 2,
                                          spacing: 8,
                                          radius: 16,
                                          dotWidth: 16,
                                          dotHeight: 16,
                                          dotColor: Color(0xFF9E9E9E),
                                          activeDotColor: Color(0xFF3F51B5),
                                          paintStyle: PaintingStyle.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(),
                          Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            color: Color(0xFFF5F5F5),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment(0, 0),
                                  child: Image.network(
                                    'https://thumbs.dreamstime.com/b/pink-magic-mirror-cartoon-wonderful-64577704.jpg',
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    fit: BoxFit.fitHeight,
                                  ),
                                )
                              ],
                            ),
                          ),
                          FFButtonWidget(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MagicMirror2Widget(),
                                ),
                              );
                            },
                            text: 'Try the MagicMirror',
                            options: FFButtonOptions(
                              width: 180,
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
                          )
                        ],
                      ),
                    ),
                  ),
                ))) */
        );
  }
}
