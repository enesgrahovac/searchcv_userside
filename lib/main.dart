import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hexcolor/hexcolor.dart';
import 'globals.dart';
import 'PostTitle.dart';
import 'DateTimeSelector.dart';
import 'PostDescription.dart';
import 'package:flutter_tags/flutter_tags.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      title: 'Flutter Demo',
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final firestoreInstance = Firestore.instance;
  static String googleRed = "#EA4335";
  static String googleGreen = "#34A853";
  static String googleBlue = "#4285F4";
  static String googleYellow = "#FBBC05";
  final List<String> googleColorPattern = [
    googleBlue,
    googleRed,
    googleYellow,
    googleBlue,
    googleGreen,
    googleRed
  ];
  RichText googleName;

  List<int> runAnimations;

  Widget chosenDatetime;
  Widget postTitle;
  Widget postDescription;
  // Widget doneButton;

  List<Widget> allWidgets;
  List<Widget> _children;
  DateTime _now;

  List<String> _tags;
  List<String> _chosenTags;
  List<String>
      _newTags; // list of tags that weren't previously in the database.

  TextEditingController _postTitleController;
  TextEditingController _postDescriptionController;

  final _formKey = GlobalKey<FormState>();

  List<TextSpan> _googleizeName(name) {
    List<TextSpan> inputLetters = [];
    int patternIndex = 0;
    for (var i = 0; i < name.length; i++) {
      String letter = name[i];
      TextSpan letterStyle;
      if (letter != " ") {
        var stringColorInPattern = googleColorPattern[patternIndex % 6];
        letterStyle = TextSpan(
          text: letter,
          style: TextStyle(
            // fontWeight: FontWeight.bold,
            fontFamily: 'ProductSans',
            color: Hexcolor(stringColorInPattern),
          ),
        );
        patternIndex += 1;
      } else {
        letterStyle = TextSpan(
          text: letter,
          style: TextStyle(
            // fontWeight: FontWeight.bold,
            fontFamily: 'ProductSans',
          ),
        );
      }
      inputLetters.add(letterStyle);
    }
    return inputLetters;
  }

  // Get previous tags from Firebase CloudStore
  getTags() async {
    List returnVal;
    var res = await firestoreInstance
        .collection('tags')
        .getDocuments()
        .then((value) => {returnVal = value.documents});

    _tags = [];
    for (var i = 0; i < returnVal.length; i++) {
      DocumentSnapshot singleDocument = returnVal[i];
      _tags.add(singleDocument.documentID);
    }
    print(_tags);

    setState(() {
      return;
    });
  }

  // Initializer
  @override
  void initState() {
    _tags = [];
    _chosenTags = [];
    _newTags = [];
    getTags();
    _now = DateTime.now();
    _postTitleController = TextEditingController();
    _postDescriptionController = TextEditingController();
    googleName = RichText(
      // textAlign: TextAlign.end,
      text: TextSpan(
        style: TextStyle(
          fontSize: 36,
        ),
        children: _googleizeName("Enes Grahovac"),
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  recordNewTag(documentID) async {
    for (int i = 0; i < _newTags.length; i++) {
      var res = await firestoreInstance
          .collection('tags')
          .document(_newTags[i])
          .setData({"posts": documentID});
    }
    return;
  }

  sendPost(Map<String, dynamic> submitData) async {
    DocumentReference resultValue;
    var res = await firestoreInstance
        .collection('posts')
        .add(submitData)
        .then((value) => {resultValue = value});

    // Check if this post used a new tag that needs to be
    // added to the 'tags' collection in Firebase.
    if (_newTags.length != 0) {
      recordNewTag(resultValue.documentID);
    }
  }

  validateSubmit() {
    bool submitValid = false;

    if (_postTitleController.text == "") {
      submitValid = false;
    } else {
      submitValid = true;
    }

    if (_postDescriptionController.text == "") {
      submitValid = false;
    } else {
      submitValid = true;
    }
    if (_chosenTags.length == 0) {
      submitValid = false;
    } else {
      submitValid = true;
    }
    if (submitValid == true) {
      Map<String, dynamic> submitData = {
        "date": _now,
        "description": _postDescriptionController.text,
        "title": _postTitleController.text,
        "tags": _chosenTags,
      };
      sendPost(submitData);

      // Clear form data after submit.
      setState(() {
        _postDescriptionController.text = "";
        _postTitleController.text = "";
        _chosenTags = [];
      });
    }
  }

  changeView() {
    print("change to post view");
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double searchbarWidth = width * .95; // width of search bar minus icons

    postTitle = Container(
      height: searchBarHeight +
          2 * searchBarPadding, //Actually 46 on Googles Search page
      padding: EdgeInsets.fromLTRB(0, searchBarPadding, 0, searchBarPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: searchbarWidth,
            height: searchBarHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(searchBarHeight / 2),
              border: Border.all(
                color: Hexcolor(googleSearchBorderColor),
                width: 1,
              ),
              color: Hexcolor(googleWhite),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
                ),
                Container(
                  width: searchbarWidth - 60,
                  child: TextField(
                    controller: _postTitleController,
                    onTap: () {},
                    cursorColor: Colors.black,
                    cursorWidth: 1,
                    enableSuggestions: false,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontFamily: googleSearchFont,
                    ),
                    onChanged: (text) {},
                    decoration: InputDecoration(
                      hintText: "Title of Post",
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    postDescription = Container(
      height: searchBarHeight +
          2 * searchBarPadding, //Actually 46 on Googles Search page
      padding: EdgeInsets.fromLTRB(0, searchBarPadding, 0, searchBarPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: searchbarWidth,
            height: searchBarHeight,
            // foregroundDecoration: BoxDecoration(
            // color: Colors.white,
            // ),
            // Search Bar Searchbar
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(searchBarHeight / 2),
              border: Border.all(
                color: Hexcolor(googleSearchBorderColor),
                width: 1,
              ),
              color: Hexcolor(googleWhite),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
                  // color: Colors.red,
                ),
                Container(
                  width: searchbarWidth - 60,
                  child: TextField(
                    controller: _postDescriptionController,
                    cursorColor: Colors.black,
                    cursorWidth: 1,
                    enableSuggestions: false,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontFamily: googleSearchFont,
                    ),
                    onChanged: (text) {},
                    decoration: InputDecoration(
                      hintText: "Description of Post",
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    chosenDatetime = Container(
      height: height * .1,
      child: CupertinoDatePicker(
        // mode:CupertinoDatePickerMode.date,
        initialDateTime: _now,
        onDateTimeChanged: (date) {
          setState(() {
            _now = date;
          });
        },
      ),
    );

    Widget tagSelector = Tags(
      horizontalScroll: true,
      // key: _tagStateKey,
      textField: TagsTextField(
        textStyle: TextStyle(fontSize: 12.0),
        constraintSuggestion: false,
        suggestions: _tags,
        onSubmitted: (String str) {
          // Add item to the data source.
          setState(() {
            // required
            _chosenTags.add(str);
            if (!_tags.contains(str)) {
              _newTags.add(str);
            }
            print("UPDATED TAGS");
            print(_chosenTags);
          });
        },
      ),
      itemCount: _chosenTags.length, // required
      itemBuilder: (int index) {
        final item = _chosenTags[index];

        return ItemTags(
          // Each ItemTags must contain a Key. Keys allow Flutter to
          // uniquely identify widgets.
          key: Key(index.toString()),
          index: index, // required
          title: item,
          pressEnabled: false,
          // active: item.active,
          // customData: item.customData,
          textStyle: TextStyle(
            fontSize: 12.0,
          ),
          combine: ItemTagsCombine.withTextBefore,
          // image: ItemTagsImage(
          //     image: AssetImage(
          //         "img.jpg") // OR NetworkImage("https://...image.png")
          //     ),
          // icon: ItemTagsIcon(
          //   icon: Icons.add,
          // ), // OR null,
          removeButton: ItemTagsRemoveButton(
            onRemoved: () {
              // Remove the item from the data source.
              setState(() {
                // required
                _chosenTags.removeAt(index);
              });
              //required
              return true;
            },
          ), // OR null,
          onPressed: (item) => print(item),
          onLongPressed: (item) => print(item),
        );
      },
    );

    Widget submitButton = FlatButton(
      onPressed: () {
        validateSubmit();
      },
      child: Container(
        width: 100,
        height: searchBarHeight,
        // foregroundDecoration: BoxDecoration(
        // color: Colors.white,
        // ),
        // Search Bar Searchbar
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(searchBarHeight / 2),
          border: Border.all(
            color: Hexcolor(googleSearchBorderColor),
            width: 1,
          ),
          color: Hexcolor(googleWhite),
        ),
        alignment: Alignment.center,
        child: Text("Submit"),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: Row(
          children: [
            Container(
              child: googleName,
              width: width * .65,
              height: 50,
            ),
            GestureDetector(
              onTap: () {
                changeView();
              },
              child: Container(
                  alignment: Alignment.center,
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50 / 2),
                    border: Border.all(
                      color: Hexcolor(googleSearchBorderColor),
                      width: 1,
                    ),
                    color: Hexcolor(googleWhite),
                  ),
                  child: Text("Switch View",style:TextStyle(fontSize: 10.0,color: Colors.black,))),
            )
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            chosenDatetime,
            postTitle,
            postDescription,
            tagSelector,
            submitButton,
          ],
        ),
      ),
    );
  }
}
