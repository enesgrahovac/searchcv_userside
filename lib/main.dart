import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hexcolor/hexcolor.dart';
import 'globals.dart';

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

  DateTime _now;

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

  // Initializer
  @override
  void initState() {
    _now = DateTime.now();
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
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double searchbarWidth = width * .95; // width of search bar minus icons

    Container postTitle = Container(
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
                    // onTap: () {
                    //   focusSearch();
                    // },
                    // controller: searchInputController,
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: Container(
          child: googleName,
          width: width,
          height: 50,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: height * .1,
            child: CupertinoDatePicker(
              initialDateTime: _now,
              onDateTimeChanged: (date) {
                setState(() {
                  _now = date;
                  print(_now);
                });
              },
            ),
          ),
          postTitle,
          postTitle,
        ],
      ),
    );
  }
}
