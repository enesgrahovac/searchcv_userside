import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hexcolor/hexcolor.dart';
import 'globals.dart';
import 'PostTitle.dart';
import 'DateTimeSelector.dart';
import 'PostDescription.dart';

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

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  double _transitionPercent;

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

  DateTimeSelector chosenDatetime;
  PostTitle postTitle;
  PostDescription postDescription;
  // Widget doneButton;

  List<Widget> allWidgets;
  List<Widget> _children;

  int focusedWidget;
  int tappedWidget;

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
    focusedWidget = null;

    googleName = RichText(
      // textAlign: TextAlign.end,
      text: TextSpan(
        style: TextStyle(
          fontSize: 36,
        ),
        children: _googleizeName("Enes Grahovac"),
      ),
    );

    _transitionPercent = 0;
    runAnimations = [0, 0, 0];

    chosenDatetime = DateTimeSelector(
      callFieldDispersion: _callFieldDispersion,
      doneWithEdit: doneWithEdit,
    );

    postTitle = PostTitle(
      callFieldDispersion: _callFieldDispersion,
      doneWithEdit: doneWithEdit,
    );

    postDescription = PostDescription(
      callFieldDispersion: _callFieldDispersion,
      doneWithEdit: doneWithEdit,
    );

    allWidgets = [chosenDatetime, postTitle, postDescription];

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  doneWithEdit() {
    focusedWidget = null;
    setState(() {
      focusedWidget = null;
    });
    runAnimations = List<int>.generate(runAnimations.length, (i) => 0);
  }

  _callFieldDispersion(indexOfFocused) async {
    tappedWidget = indexOfFocused;
    runAnimations = List<int>.generate(runAnimations.length,
        (i) => (i == indexOfFocused) ? 0 : (i < indexOfFocused) ? 1 : 2);
    // chosenDatetime.
    for (int index = 0; index < runAnimations.length; index++) {
      // Animate the DateTimeSelector widget
      if (index == 0) {
        if (runAnimations[index] == 0) {
          // do nothing
        } else if (runAnimations[index] == 1) {
          DateTimeSelector.globalKey.currentState.animateUp();
          // do nothing
        } else if (runAnimations[index] == 2) {
          DateTimeSelector.globalKey.currentState.animateDown();
          // do nothing
        }
      }

      // Animate the Post Title Widget
      else if (index == 1) {
        if (runAnimations[index] == 0) {
          // do nothing
        } else if (runAnimations[index] == 1) {
          PostTitle.globalKey.currentState.animateUp();
        } else if (runAnimations[index] == 2) {
          PostTitle.globalKey.currentState.animateDown();
        }
      }

      // Animate the Post Description Widget
      else if (index == 2) {
        if (runAnimations[index] == 0) {
          // do nothing
        } else if (runAnimations[index] == 1) {
          PostDescription.globalKey.currentState.animateUp();
        } else if (runAnimations[index] == 2) {
          PostDescription.globalKey.currentState.animateDown();
        }
      }
    }
    int waitTime = (animationTime / 5).round();
    await new Future.delayed(Duration(milliseconds: waitTime));
    focusedWidget = tappedWidget;
    if (focusedWidget == null) {
      _children = allWidgets;
    } else {
      _children = [allWidgets[focusedWidget]];
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double searchbarWidth = width * .95; // width of search bar minus icons

    if (focusedWidget == null) {
      _children = allWidgets;
    } else {
      _children = [allWidgets[focusedWidget]];
    }
    print("CHILDREN");
    print(_children);
    print(focusedWidget);

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
        children: _children,
      ),
    );
  }
}
