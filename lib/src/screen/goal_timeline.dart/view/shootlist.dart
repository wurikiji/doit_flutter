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

class _DoitTimelineShootListState extends State<DoitTimelineShootList> with SingleTickerProviderStateMixin {
  double height = 120.0;
  AnimationController _animationController;
  Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset(0, 0.73),
      end: Offset(0, 0),
    ).animate(
      _animationController.drive(
        CurveTween(
          curve: Curves.easeIn,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onVerticalDragUpdate: (dragInfo) {
        double velocity = dragInfo.delta.dy;
        if (velocity < 0) {
          _animationController.reset();
          _animationController.fling();
        } else {
          _animationController.fling(velocity: -1.0);
        }

        setState(() {
          height -= velocity;
          if (height < 120) height = 120;
          if (height > maxHeight) height = maxHeight;
        });
      },
      onVerticalDragEnd: (dragInfo) {},
      behavior: HitTestBehavior.deferToChild,
      child: SafeArea(
        child: SlideTransition(
          position: _offsetAnimation,
          child: Container(
            height: maxHeight,
            margin: EdgeInsets.only(top: 80),
            padding: EdgeInsets.only(bottom: 20.0),
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
                DoitShootlistTopTouchArea(animationController: _animationController),
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
    @required AnimationController animationController,
  })  : _animationController = animationController,
        super(key: key);

  final AnimationController _animationController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        if (_animationController.value > 0.5) {
          _animationController.fling(velocity: -1.0);
        } else {
          _animationController.fling();
        }
      },
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
