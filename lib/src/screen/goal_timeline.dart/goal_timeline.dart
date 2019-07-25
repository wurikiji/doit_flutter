import 'package:do_it/src/common_view/doit_bottom_widget.dart';
import 'package:do_it/src/screen/goal_timeline.dart/view/shootlist.dart';
import 'package:do_it/src/screen/goal_timeline.dart/view/timeline_backdrop.dart';
import 'package:do_it/src/service/api/goal_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DoitTimeline extends StatelessWidget {
  DoitTimeline({
    @required this.goal,
  });
  final DoitGoalModel goal;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: DoitFloatingActionButton(
        goal: goal,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Stack(
        fit: StackFit.loose,
        children: <Widget>[
          DoitTimelineBackdrop(goal: goal),
          Align(
            alignment: Alignment.bottomCenter,
            child: DoitTimelineShootList(goal: goal),
          ),
        ],
      ),
    );
  }
}

const TextStyle descTextStyle = const TextStyle(
  color: Colors.white,
  fontSize: 14.0,
  fontFamily: 'SpoqaHanSans',
  fontWeight: FontWeight.normal,
);

const TextStyle titleBoldTextStyle = TextStyle(
  fontFamily: 'SpoqaHanSans',
  fontSize: 30.0,
  fontWeight: FontWeight.w700,
);
