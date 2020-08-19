import 'globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hexcolor/hexcolor.dart';

class DateTimeSelector extends StatefulWidget {
  static final GlobalKey<_DateTimeSelectorState> globalKey =
      GlobalKey<_DateTimeSelectorState>();

  DateTimeSelector({
    @required callFieldDispersion,
    @required doneWithEdit,
  })  : _callFieldDispersion = callFieldDispersion,
        doneWithEdit = doneWithEdit,
        super(key: globalKey);

  final Function _callFieldDispersion;
  final Function doneWithEdit;

  @override
  _DateTimeSelectorState createState() => _DateTimeSelectorState();
}

class _DateTimeSelectorState extends State<DateTimeSelector>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  double _transitionPercent;
  DateTime _now;
  int animationDirection;

  // Initializer
  @override
  void initState() {
    animationDirection = 0;
    _now = DateTime.now();

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
    if (animationDirection == 2) {
      contentOffset = contentOffset * -1;
    }
    return Transform(
      transform: Matrix4.translationValues(0, contentOffset, 0)
        ..scale(contentScale, contentScale),
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () {
          widget._callFieldDispersion(0);
        },
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
      ),
    );
  }
}
