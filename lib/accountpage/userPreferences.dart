import 'package:magic_mirror/accountpage/picProfileWIdget.dart';
import 'package:magic_mirror/accountpage/user_preference.dart';
import 'package:magic_mirror/backend/schema/users_record.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:magic_mirror/home_page/home_page_widget.dart';
import '../auth/auth_util.dart';
import '../components/mado_widget.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import '../login/login_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shared_preferences/shared_preferences.dart';

class userPreferencesWidget extends StatefulWidget {
  final UsersRecord record;
  userPreferencesWidget(this.record, {Key key}) : super(key: key);

  @override
  _userPreferencesWidgetState createState() => _userPreferencesWidgetState();
}

class _userPreferencesWidgetState extends State<userPreferencesWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> tagsList = ['Dan Brown', 'J. K. Rowling', 'George Orwell', 'Haruki Murakami', 'Gabriel García Márquez'];
  List<String> selectedTags = []; //for the authors
  List<String> tagsListGenres = ['Thriller', 'Fantasy', 'Historical', 'Drama', 'Sci-Fi', 'Horror', 'Mistery'];
  List<String> selectedTagsGenres = ["Thriller"]; //for the genres


  @override
  void initState() {
    super.initState();

    getPrefAuth("prefAuthors").then((value) {
      if (value != null) {
       selectedTags = value;
      }
      else {
        selectedTags = [];
      }
    });

    getPrefGenres("prefGenres").then((value) {
      if (value != null) {
        selectedTagsGenres = value;
      }
      else {
        selectedTagsGenres = [];
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    final user = UserPreferences.myUser;
    return FutureBuilder(
        future: Future.wait([
          getPrefAuth("prefAuthors"),
          getPrefGenres("prefGenres"),
        ]),
        builder: (BuildContext context, AsyncSnapshot<List<List<String>>> snapshot) {
          if (snapshot.hasData) {
            selectedTags = snapshot.data[0];
            selectedTagsGenres = snapshot.data[1];
            //print("Has data!");
            return Scaffold(
              key: scaffoldKey,
              body: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 15, 15, 0),
                  height: 50,
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
                  ProfileWidget(
                    imagePath: user.imagePath,
                    onClicked: () async {},
                  ),
                  const SizedBox(height: 24),
                  buildUser(widget.record),
                  const SizedBox(height: 24),
                  buildAboutAuthors(widget.record),
                  const SizedBox(height: 24),
                  buildAboutGenres(widget.record),
                ],
              ),
            );
          } else {
            print("No data!");
            return CircularProgressIndicator();
          }

    });


  }

  Widget buildUser(UsersRecord record) => Column(
        children: [
          Text(record.username,
              style: FlutterFlowTheme.bodyText1.override(
                  fontFamily: "Poppins",
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(record.email,
              style: FlutterFlowTheme.bodyText1.override(
                fontFamily: "Poppins",
              )),
        ],
      );

  Future<List<String>> getPrefAuth(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList("prefAuthors") == null) ? [] : prefs.getStringList("prefAuthors");
  }

  Future<List<String>> getPrefGenres(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList("prefGenres") == null) ? [] : prefs.getStringList("prefGenres");
  }


  _addListStringToSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (key=="prefAuthors") {
      prefs.setStringList("prefAuthors", selectedTags);
    } else {
      prefs.setStringList("prefGenres", selectedTagsGenres);
    }

  }

  _addSuggestion(String value, String key) {
    //print("added " + value + " to SP");
    if (key=="prefAuthors") {
      final String exists = tagsList.firstWhere((text) => text ==value,orElse: () {return null;});
      if(exists !=null) {
        final String isAlreadyInSelectedList = selectedTags.firstWhere((text) => text ==value,orElse: () {return null;});
        if(isAlreadyInSelectedList ==null) {
          setState(() async {
            selectedTags.add(value);
            tagsList.remove(value);
            await _addListStringToSF("prefAuthors");
          });
        }
      }
      else {
        final String isAlreadyInSelectedList = selectedTags.firstWhere((text) => text==value,orElse: () {return null;});
        if(isAlreadyInSelectedList ==null) {
          setState(() {
            selectedTags.add(value);
            _addListStringToSF("prefAuthors");
//          tagsList.add(value);
          });
        }
      }
    } else {
      final String exists = tagsListGenres.firstWhere((text) => text ==value,orElse: () {return null;});
      if(exists !=null) {
        final String isAlreadyInSelectedList = selectedTagsGenres.firstWhere((text) => text ==value,orElse: () {return null;});
        if(isAlreadyInSelectedList ==null) {
          setState(() async {
            selectedTagsGenres.add(value);
            tagsListGenres.remove(value);
            await _addListStringToSF("prefGenres");
          });
        }
      }
      else {
        final String isAlreadyInSelectedList = selectedTagsGenres.firstWhere((text) => text==value,orElse: () {return null;});
        if(isAlreadyInSelectedList ==null) {
          setState(() {
            selectedTagsGenres.add(value);
            _addListStringToSF("prefGenres");
//          tagsList.add(value);
          });
        }
      }
    }



  }

  _onSuggestionRemoved(String value, String key) {

    if (key=="prefAuthors") {
      final String exists =
      selectedTags.firstWhere((text) => text == value, orElse: () {
        return null;
      });
      if (exists != null) {
        setState(() {
          selectedTags.remove(value);
          tagsList.add(value);
          _addListStringToSF(key);
        });
      }
    } else {
      final String exists =
      selectedTagsGenres.firstWhere((text) => text == value, orElse: () {
        return null;
      });
      if (exists != null) {
        setState(() {
          selectedTagsGenres.remove(value);
          tagsListGenres.add(value);
          _addListStringToSF(key);
        });
      }

    }


  }

  _onSuggestionSelected(String value, String key) {
    if (key=="prefAuthors") {
      final String exists =
      tagsList.firstWhere((text) => text == value, orElse: () {
        return null;
      });
      if (exists != null) {
        final String isAlreadyInSelectedList =
        selectedTags.firstWhere((text) => text == value, orElse: () {
          return null;
        });

        if (isAlreadyInSelectedList == null) {
          setState(() {
            selectedTags.add(value);
            tagsList.remove(value);
            _addListStringToSF(key);
          });
        }
      }
    } else {
      final String exists =
      tagsListGenres.firstWhere((text) => text == value, orElse: () {
        return null;
      });
      if (exists != null) {
        final String isAlreadyInSelectedList =
        selectedTagsGenres.firstWhere((text) => text == value, orElse: () {
          return null;
        });

        if (isAlreadyInSelectedList == null) {
          setState(() {
            selectedTagsGenres.add(value);
            tagsListGenres.remove(value);
            _addListStringToSF(key);
          });
        }
      }
    }


  }

  _suggestionList({@required List<String> tags, @required String suggestion}) {
    List<String> modifiedList = [];
    modifiedList.addAll(tags);
    modifiedList.retainWhere(
            (text) => text.toLowerCase().contains(suggestion.toLowerCase()));
    if (suggestion.length >= 2) {
      return modifiedList;
    } else {
      return null;
    }
  }

  _generateAuthorsTags() {
    return selectedTags.isEmpty
        ? Container()
        : Container(
      alignment: Alignment.topLeft,
      child: Tags(
        alignment: WrapAlignment.center,
        itemCount: selectedTags.length,
        itemBuilder: (index) {
          return ItemTags(
            index: index,
            title: selectedTags[index],
            color: Colors.blue,
            activeColor: Colors.red,
            onPressed: (Item item) {
              print('pressed');
            },
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            elevation: 0.0,
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
//                textColor: ,
            textColor: Colors.white,
            textActiveColor: Colors.white,
            removeButton: ItemTagsRemoveButton(
                color: Colors.black,
                backgroundColor: Colors.transparent,
                size: 14,
                onRemoved: () {
                  _onSuggestionRemoved(selectedTags[index], "prefAuthors");
                  return true;
                }),
            textOverflow: TextOverflow.ellipsis,
          );
        },
      ),
    );
  }

  _generateGenresTags() {
    return selectedTagsGenres.isEmpty
        ? Container()
        : Container(
      alignment: Alignment.topLeft,
      child: Tags(
        alignment: WrapAlignment.center,
        itemCount: selectedTagsGenres.length,
        itemBuilder: (index) {
          return ItemTags(
            index: index,
            title: selectedTagsGenres[index],
            color: Colors.blue,
            activeColor: Colors.red,
            onPressed: (Item item) {
              print('pressed');
            },
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            elevation: 0.0,
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
//                textColor: ,
            textColor: Colors.white,
            textActiveColor: Colors.white,
            removeButton: ItemTagsRemoveButton(
                color: Colors.black,
                backgroundColor: Colors.transparent,
                size: 14,
                onRemoved: () {
                  _onSuggestionRemoved(selectedTagsGenres[index], "prefGenres");
                  return true;
                }),
            textOverflow: TextOverflow.ellipsis,
          );
        },
      ),
    );
  }

  final fieldTextAuthors = TextEditingController();
  void clearTextAuthors() {
    fieldTextAuthors.clear();
  }

  final fieldTextGenres = TextEditingController();
  void clearTextGenres() {
    fieldTextGenres.clear();
  }

  Widget buildAboutAuthors(UsersRecord record) => Container(
    padding: EdgeInsets.symmetric(horizontal: 48),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            "Preferred Authors"
        ),
        TypeAheadField(
          textFieldConfiguration: TextFieldConfiguration(
            autofocus: false,
            controller: fieldTextAuthors,
            onSubmitted: (val) {
              print('runtime type of val is ${val.runtimeType}');
              _addSuggestion(val, "prefAuthors");
              fieldTextAuthors.clear();
            }
          ),
          hideOnLoading: true,
          hideOnEmpty: true,
          getImmediateSuggestions: false,
          onSuggestionSelected: (val) {
            _onSuggestionSelected(val, "prefAuthors");
            fieldTextAuthors.clear();
          },
          itemBuilder: (context, suggestion) {
            return ListTile(
              title: Text(
                suggestion,
              ),
            );
          },
          suggestionsCallback: (val) {
            return _suggestionList(
              tags: tagsList,
              suggestion: val,
            );
  //          return ;
          },
        ),
        SizedBox(
          height: 20,
        ),
        _generateAuthorsTags(),
        const SizedBox(height: 6),
      ],
    ),
  );

  Widget buildAboutGenres(UsersRecord record) => Container(
    padding: EdgeInsets.symmetric(horizontal: 48),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            "Preferred Genres"
        ),
        TypeAheadField(
          textFieldConfiguration: TextFieldConfiguration(
              autofocus: false,
              controller: fieldTextGenres,
              onSubmitted: (val) {
                print('runtime type of val is ${val.runtimeType}');
                _addSuggestion(val, "prefGenres");
                fieldTextGenres.clear();
              }
          ),
          hideOnLoading: true,
          hideOnEmpty: true,
          getImmediateSuggestions: false,
          onSuggestionSelected: (val) {
            _onSuggestionSelected(val, "prefGenres");
            fieldTextGenres.clear();
          },
          itemBuilder: (context, suggestion) {
            return ListTile(
              title: Text(
                suggestion,
              ),
            );
          },
          suggestionsCallback: (val) {
            return _suggestionList(
              tags: tagsListGenres,
              suggestion: val,
            );
            //          return ;
          },
        ),
        SizedBox(
          height: 20,
        ),
        _generateGenresTags(),
        const SizedBox(height: 6),
      ],
    ),
  );

}
