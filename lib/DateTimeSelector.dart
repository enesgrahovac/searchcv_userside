import 'globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hexcolor/hexcolor.dart';

class DateTimeSelector extends StatefulWidget {
  static final GlobalKey<_DateTimeSelectorState> globalKey =
      GlobalKey<_DateTimeSelectorState>();

  DateTimeSelector() : super(key: globalKey);

  @override
  _DateTimeSelectorState createState() => _DateTimeSelectorState();
}

class _DateTimeSelectorState extends State<DateTimeSelector> {
  DateTime _now;
  int animationDirection;

  // Initializer
  @override
  void initState() {
    _now = DateTime.now();

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

    return GestureDetector(
      child: Container(
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
      ),
    );
  }
}
