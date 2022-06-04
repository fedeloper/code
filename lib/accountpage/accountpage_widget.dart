import 'package:flutter/material.dart';
import 'package:magic_mirror/accountpage/userPreferences.dart';
import 'package:magic_mirror/backend/backend.dart';
import 'package:magic_mirror/backend/schema/users_record.dart';
import 'package:magic_mirror/home_page/home_page_widget.dart';
import 'package:magic_mirror/searchstory/searchstory_widget.dart';

import '../auth/auth_util.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import '../login/login_widget.dart';

class AccountpageWidget extends StatefulWidget {
  AccountpageWidget({Key key}) : super(key: key);

  @override
  _AccountpageWidgetState createState() => _AccountpageWidgetState();
}

class _AccountpageWidgetState extends State<AccountpageWidget> {
  TextEditingController emailTextController;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    emailTextController = TextEditingController(text: currentUserEmail);
  }
  int _selectedIndex = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
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
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(0, 15, 15, 0),
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePageWidget(),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 14.0,
                      backgroundColor: Colors.white,
                      //foregroundColor: Colors.blue,
                      child: Icon(Icons.close, color: Colors.black),
                    ),
                  ), //Icon(Icons.close),
                ],
              ),
            ),
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
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(24, 12, 0, 12),
                      child: Text(
                        'Account Settings',
                        style: FlutterFlowTheme.bodyText1.override(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            InkWell(child:Padding(
                              padding: EdgeInsets.fromLTRB(24, 0, 0, 0),
                              child: Text(
                                'Preferences',
                                style: FlutterFlowTheme.bodyText1.override(
                                  fontFamily: 'Poppins',
                                ),
                              ),

                            ),
                            onTap: () {
    StreamBuilder<List<UsersRecord>>(
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

                                Navigator.push(
                                context,
                                MaterialPageRoute(
                                builder: (context) =>   userPreferencesWidget(madoUsersRecord)));

                                });})
                            ,
                            Expanded(
                              child: Align(
                                alignment: Alignment(0.9, 0),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Color(0xFF95A1AC),
                                  size: 18,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 1, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(24, 0, 0, 0),
                                child: Text(
                                  'Settings',
                                  style: FlutterFlowTheme.bodyText1.override(
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment(0.9, 0),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Color(0xFF95A1AC),
                                    size: 18,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 1, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(24, 0, 0, 0),
                                child: Text(
                                  'Notifications',
                                  style: FlutterFlowTheme.bodyText1.override(
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment(0.9, 0),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Color(0xFF95A1AC),
                                    size: 18,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 1, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                          ),
                          child: InkWell(
                            onTap: () async {
                              if (emailTextController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Email required!',
                                    ),
                                  ),
                                );
                                return;
                              }
                              await resetPassword(
                                email: emailTextController.text,
                                context: context,
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(24, 0, 0, 0),
                                  child: Text(
                                    'Change Password',
                                    style: FlutterFlowTheme.bodyText1.override(
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment(0.9, 0),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Color(0xFF95A1AC),
                                      size: 18,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(150, 0, 100, 0),
                          child: FFButtonWidget(
                            onPressed: () async {
                              await signOut();
                              await Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginWidget(),
                                ),
                                (r) => false,
                              );
                            },
                            text: 'Log Out',
                            options: FFButtonOptions(
                              width: 90,
                              height: 40,
                              color: Colors.white,
                              textStyle: FlutterFlowTheme.bodyText2.override(
                                fontFamily: 'Poppins',
                                color: FlutterFlowTheme.primaryColor,
                              ),
                              elevation: 3,
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 1,
                              ),
                              borderRadius: 8,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: emailTextController,
                            obscureText: false,
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: '[Some hint text...]',
                              hintStyle: FlutterFlowTheme.bodyText1.override(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontWeight: FontWeight.w100,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0x00000000),
                                  width: 1,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0x00000000),
                                  width: 1,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                            ),
                            style: FlutterFlowTheme.bodyText1.override(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                        )
                      ],
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
}
