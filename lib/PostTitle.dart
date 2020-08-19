import 'globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hexcolor/hexcolor.dart';

class PostTitle extends StatefulWidget {
  static final GlobalKey<_PostTitleState> globalKey =
      GlobalKey<_PostTitleState>();

  PostTitle({
    @required callFieldDispersion,
    @required doneWithEdit,
  })  : _callFieldDispersion = callFieldDispersion,
        doneWithEdit = doneWithEdit,
        super(key: globalKey);

  final Function _callFieldDispersion;
  final Function doneWithEdit;

  // super(key:_postTitleKey);

  @override
  _PostTitleState createState() => _PostTitleState();
}

class _PostTitleState extends State<PostTitle>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  double _transitionPercent;
  int animationDirection;
  TextEditingController _textController;
  bool isFocused;
  Widget inputBar;
  List<Widget> _children;

  // Initializer
  @override
  void initState() {
    _textController = TextEditingController();
    isFocused = false;
    animationDirection = 0;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: animationTime),
    )
      ..addListener(() {
        setState(() {
          _transitionPercent = _animationController.value;
        });
      })
      ..addStatusListener((status) {
        setState(() {
          if (status == AnimationStatus.completed) {
            _animationController.value = 0;
            _transitionPercent = 0;
            animationDirection = 0;
          }
        });
      });

    _transitionPercent = 0;

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animateUp() {
    animationDirection = 1;
    _animationController.forward();
  }

  animateDown() {
    animationDirection = 2;
    _animationController.forward();
  }

  animateBack() {
    _animationController.reverse();
  }

  callDispersion() async {
    widget._callFieldDispersion(1);
    int waitTime = (animationTime / 5).round();
    await new Future.delayed(Duration(milliseconds: waitTime));
    setState(() {
      isFocused = true;
    });
  }

  doneWithEdit() {
    setState(() {
      print(_textController.value);
      isFocused = false;
      FocusScope.of(context).unfocus();
      widget.doneWithEdit();
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double searchbarWidth = width * .95; // width of search bar minus icons
    // Calculate the position of the onboarding content
    final double maxOffset = width / 1;

    double offsetPercent = 1;

    offsetPercent = -_transitionPercent / 0.25;

    double contentOffset = offsetPercent * maxOffset;
    final double contentScale = 0.6 + (0.4 * (1.0 - offsetPercent.abs()));

    if (animationDirection == 2) {
      contentOffset = contentOffset * -1;
    }

    inputBar = Transform(
      transform: Matrix4.translationValues(0, contentOffset, 0),
      // ..scale(contentScale, contentScale),
      alignment: Alignment.center,
      child: Container(
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
                      onTap: () {
                        callDispersion();
                      },
                      controller: _textController,
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
      ),
    );

    Widget doneButton = FlatButton(
        onPressed: () {
          doneWithEdit();
        },
        child: Text("DONE"));

    if (isFocused) {
      _children = [inputBar, doneButton];
    } else {
      _children = [inputBar];
    }

    return Column(children: _children);
  }
}
