import 'globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hexcolor/hexcolor.dart';

class PostDescription extends StatefulWidget {
  static final GlobalKey<_PostDescriptionState> globalKey =
      GlobalKey<_PostDescriptionState>();

  PostDescription() :
        super(key: globalKey);


  @override
  _PostDescriptionState createState() => _PostDescriptionState();
}

class _PostDescriptionState extends State<PostDescription> {
  // Initializer
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double searchbarWidth = width * .95; // width of search bar minus icons

    return Container(
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
  }
}
