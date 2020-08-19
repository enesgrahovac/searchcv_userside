import 'globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hexcolor/hexcolor.dart';

class PostDescription extends StatefulWidget {
  static final GlobalKey<_PostDescriptionState> globalKey =
      GlobalKey<_PostDescriptionState>();

  PostDescription({
    @required callFieldDispersion,
    @required doneWithEdit,
  })  : _callFieldDispersion = callFieldDispersion,
        doneWithEdit = doneWithEdit,
        super(key: globalKey);

  final Function _callFieldDispersion;
  final Function doneWithEdit;

  @override
  _PostDescriptionState createState() => _PostDescriptionState();
}

class _PostDescriptionState extends State<PostDescription>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  double _transitionPercent;
  int animationDirection;
  // Initializer
  @override
  void initState() {
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double searchbarWidth = width * .95; // width of search bar minus icons
    // Calculate the position of the onboarding content
    final double maxOffset = width / 1;

    double offsetPercent = 1;
    // if (_transitionPercent <= 0.25) {
    //   offsetPercent = -_transitionPercent / 0.25;
    //   // print(offsetPercent);
    // } else if (_transitionPercent >= 0.7) {
    //   offsetPercent = (1.0 - _transitionPercent) / 0.3;
    //   offsetPercent = Curves.easeInCubic.transform(offsetPercent);
    // }

    offsetPercent = -_transitionPercent / 0.25;

    // offsetPercent = (1.0 - _transitionPercent) / 0.3;
    // offsetPercent = Curves.easeInCubic.transform(offsetPercent);

    double contentOffset = offsetPercent * maxOffset;
    final double contentScale = 0.6 + (0.4 * (1.0 - offsetPercent.abs()));
    if (animationDirection == 1) {
    } else if (animationDirection == 2) {
      contentOffset = contentOffset * -1;
    }
    return Transform(
      transform: Matrix4.translationValues(0, contentOffset, 0)
        ..scale(contentScale, contentScale),
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
                      onTap: () 
                      {
                        widget._callFieldDispersion(2);
                      },
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
      ),
    );
  }
}
