import 'dart:async';

import 'package:do_it/src/screen/goal_timeline.dart/view/shootlist_view.dart';
import 'package:do_it/src/service/api/goal_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class DoitTimelineShootList extends StatefulWidget {
  const DoitTimelineShootList({
    Key key,
    @required this.goal,
  }) : super(key: key);

  final DoitGoalModel goal;

  @override
  _DoitTimelineShootListState createState() => _DoitTimelineShootListState();
}

const double minHeight = 60.0;

class _DoitTimelineShootListState extends State<DoitTimelineShootList> {
  double height = minHeight;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _handleDrag(DragUpdateDetails dragInfo) async {
    final double velocity = dragInfo.delta.dy;
    double targetHeight;
    if (velocity < 0) {
      targetHeight = MediaQuery.of(context).size.height;
    } else {
      targetHeight = minHeight;
    }
    setState(() {
      height = targetHeight;
    });
  }

  _handleTouch() async {
    double targetHeight;
    if (height > 70.0) {
      targetHeight = minHeight;
    } else {
      targetHeight = MediaQuery.of(context).size.height;
    }
    setState(() {
      height = targetHeight;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (height == minHeight) {
          return true;
        } else {
          _handleTouch();
          return false;
        }
      },
      child: Align(
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
          onVerticalDragUpdate: _handleDrag,
          behavior: HitTestBehavior.deferToChild,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOutExpo,
            height: height,
            margin: EdgeInsets.only(top: 102),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(
                    10.0,
                  )),
              color: Color(0xff222222),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                DoitShootlistTopTouchArea(handleTouch: _handleTouch),
                Expanded(
                  child: ShootlistView(
                    goal: widget.goal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DoitShootlistTopTouchArea extends StatelessWidget {
  const DoitShootlistTopTouchArea({
    Key key,
    @required this.handleTouch,
  }) : super(key: key);

  final Function handleTouch;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: handleTouch,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 33.0, top: 8.0),
        child: Center(
          child: Container(
            width: 28.0,
            height: 3.0,
            decoration: BoxDecoration(
              color: Color(0xffd8d8d8),
              borderRadius: BorderRadius.circular(5.5),
            ),
          ),
        ),
      ),
    );
  }
}
