// @dart=2.9
import 'dart:developer' as developer;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:magic_mirror/accountpage/userPreferences.dart';
import 'package:magic_mirror/home_page/home_page_widget.dart';
import 'package:magic_mirror/searchstory/repository.dart';
import 'package:magic_mirror/tellingthestory/tellingv2.dart';
import  'package:string_similarity/string_similarity.dart';

import '../accountpage/accountpage_widget.dart';
import '../auth/auth_util.dart';
import '../backend/backend.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import 'book.dart';

class SearchstoryWidget extends StatefulWidget {
  SearchstoryWidget({Key key}) : super(key: key);

  @override
  _SearchstoryWidgetState createState() => _SearchstoryWidgetState();
}

class _SearchstoryWidgetState extends State<SearchstoryWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController textController;
  List<Book> books=[];
  List<Book> books_full=[];
  int _selectedIndex = 0;
  void tt() async {
    Repository rep = new Repository();

    if (books_full.length <5)
    {
     books_full = await rep.topBooks(300);
     books_full.forEach((element) {developer.log(element.title);});
    }

    String query = textController.text;

    books_full.sort((b, a) => a.title.similarityTo(query).compareTo(b.title.similarityTo(query)));
    addItemToList(books_full.sublist(0,10));

  }
  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }
  void addItemToList(List<Book> list){
    setState(() {
      this.books=list;
    });
  }
  @override
  Widget build(BuildContext context) {
    tt();
    return StreamBuilder<List<UsersRecord>>(
        stream: queryUsersRecord(
        queryBuilder: (usersRecord) =>
        usersRecord.where('email', isEqualTo: currentUserEmail),
    singleRecord: true,
    ),
    builder: (context, snapshot) {
      // Customize what your widget looks like when it's loading.
      if (!snapshot.hasData) {
        return Center(child: CircularProgressIndicator());
      }
      List<UsersRecord> madoUsersRecordList = snapshot.data;
      // Customize what your widget looks like with no query results.
      if (snapshot.data.isEmpty) {
        // return Container();
        // For now, we'll just include some dummy data.
        madoUsersRecordList = createDummyUsersRecord(count: 1);
      }
      final madoUsersRecord = madoUsersRecordList.first;
      return Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings")
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[700],
          onTap: (index ){
            List lst = [SearchstoryWidget(),HomePageWidget(),AccountpageWidget()];


            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                lst[index],
              ),
            );

          },
        ),
        body: Column(

          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.25,
              decoration: BoxDecoration(
                color: Color(0xFFEEEEEE),
              ),
              child:  Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 1,
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
                child: Align(
                  alignment: Alignment(0, 0.05),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          alignment:
                          Alignment(-0.050000000000000044, 0.10000000000000009),
                          children: [
                            Align(
                              alignment: Alignment(0, 0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Color(0x00FFFFFF),
                                ),
                                child: Align(
                                  alignment: Alignment(0.15, 0.85),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width *
                                              0.95,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(
                                              color: Color(0xFFEEEEEE),
                                              width: 2,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                            child: InkWell(
                                              onTap: () async {
                                              },
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.fromLTRB(
                                                        4, 0, 4, 0),
                                                    child: Icon(
                                                      Icons.search_rounded,
                                                      color: Color(0xFF95A1AC),
                                                      size: 24,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding: EdgeInsets.fromLTRB(
                                                          4, 0, 0, 0),
                                                      child: TextFormField(
                                                        onChanged: (text) {
                                                          tt();
                                                        },
                                                        controller: textController,
                                                        obscureText: false,
                                                        decoration: InputDecoration(
                                                          labelText:
                                                          '',
                                                          labelStyle: FlutterFlowTheme
                                                              .bodyText1
                                                              .override(
                                                            fontFamily: 'Poppins',
                                                            color: Color(0xFF95A1AC),
                                                          ),
                                                          enabledBorder:
                                                          UnderlineInputBorder(
                                                            borderSide: BorderSide(
                                                              color:
                                                              Color(0x00000000),
                                                              width: 1,
                                                            ),
                                                            borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                              topLeft:
                                                              Radius.circular(
                                                                  4.0),
                                                              topRight:
                                                              Radius.circular(
                                                                  4.0),
                                                            ),
                                                          ),
                                                          focusedBorder:
                                                          UnderlineInputBorder(
                                                            borderSide: BorderSide(
                                                              color:
                                                              Color(0x00000000),
                                                              width: 1,
                                                            ),
                                                            borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                              topLeft:
                                                              Radius.circular(
                                                                  4.0),
                                                              topRight:
                                                              Radius.circular(
                                                                  4.0),
                                                            ),
                                                          ),
                                                        ),
                                                        style: FlutterFlowTheme
                                                            .bodyText1
                                                            .override(
                                                          fontFamily: 'Poppins',
                                                          color: Color(0xFF95A1AC),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  /*
                                                  Expanded(
                                                    child: Align(
                                                      alignment: Alignment(0.95, 0),
                                                      child: Icon(
                                                        Icons.tune_rounded,
                                                        color: Color(0xFF95A1AC),
                                                        size: 24,
                                                      ),
                                                    ),
                                                  )
                                                  */
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment(-0.95, -0.86),
                              child: InkWell(
                                onTap: () async {
                                },
                                child: Icon(
                                  Icons.settings,
                                  color: Colors.black,
                                  size: 24,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment(-0.01, -0.35),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Image.asset(
                                  'assets/images/c874bc5649ca63dd5a11ae9ececfad05.png',
                                  width: MediaQuery.of(context).size.width * 0.6,
                                  height: 100,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment(0.95, -0.90),
                              child: InkWell(
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          userPreferencesWidget(madoUsersRecord),
                                    ),
                                  );
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Text(
                                    madoUsersRecord.username,
                                    style: FlutterFlowTheme.bodyText1.override(
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(

                child: books.isEmpty ? Center(child: SpinKitFoldingCube(color: Colors.blue,
                    size: 50.0)) :ListView.builder(
                    padding: const EdgeInsets.all(2),
                    itemCount: max(0,books.length-1 ),
                    itemBuilder: (BuildContext context, int index) {
                      return
                        InkWell(
                          child:  Container(

                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            height: 90,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child:
                                        Image.network(
                                          "https://archive.org/download/" +
                                              books[index].id + '/__ia_thumb.jpg',
                                          width: 74,
                                          height: 74,
                                          fit: BoxFit.cover,
                                        )

                                        ,
                                      ),
                                    )
                                  ],
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(8, 1, 0, 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                books[index].title,
                                                overflow: TextOverflow.ellipsis,
                                                style:
                                                FlutterFlowTheme.subtitle1
                                                    .override(
                                                  fontFamily: 'Poppins',
                                                  color: Color(0xFF15212B),
                                                ),
                                              ),
                                            )

                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(
                                              "author: " + books[index].author,
                                              style:
                                              FlutterFlowTheme.bodyText2.override(
                                                fontFamily: 'Poppins',
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(
                                              "rating: " +
                                                  books[index].rating.toString() +
                                                  "/5",
                                              style:
                                              FlutterFlowTheme.bodyText1.override(
                                                fontFamily: 'Poppins',
                                                color: FlutterFlowTheme
                                                    .primaryColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                                        child: Icon(
                                          Icons.chevron_right_outlined,
                                          color: Color(0xFF95A1AC),
                                          size: 24,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TellingV2(book:books[index]),
                                ),
                              );

                          },
                        );


                    }
                ))
            ,


          ],
        ),
      );
    });


  }
}
