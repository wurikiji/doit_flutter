import 'dart:async';

import 'package:do_it/src/color/doit_theme.dart';
import 'package:do_it/src/screen/main/doit_main.dart';
import 'package:do_it/src/screen/main/view/user_goal_card.dart';
import 'package:do_it/src/screen/make_goal/view/scond_page/project_color.dart';
import 'package:do_it/src/screen/shoot/shoot_timer/doit_shoot_timer.dart';
import 'package:do_it/src/screen/shoot/shoot_timer/doit_timer_main.dart';
import 'package:do_it/src/service/api/goal_service.dart';
import 'package:flutter/material.dart';

class DoitTimer extends StatefulWidget {
  DoitTimer({
    @required this.goal,
    @required this.timer,
  });

  final DoitGoalModel goal;
  final ShootTimerModel timer;
  @override
  _DoitTimerState createState() => _DoitTimerState();
}

class _DoitTimerState extends State<DoitTimer> {
  Timer _timer;
  int countDown = 3;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        countDown -= 1;
        if (countDown == 0) {
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (countDown > 0) {
      return DoitCountdown(
        countDown: countDown,
        gradient: projectColors[getProjectColorIndex(widget.goal.goalColor)],
      );
    }
    return DoitTimerMain(
      goal: widget.goal,
      timer: widget.timer,
    );
  }
}

class DoitCountdown extends StatelessWidget {
  DoitCountdown({
    @required this.countDown,
    @required this.gradient,
  });
  final int countDown;
  final LinearGradient gradient;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    height /= 2.0;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: Align(
              alignment: Alignment(0.0, -(170 / height)),
              child: Text(
                "Ready!",
                style: TextStyle(
                  fontFamily: 'SpoqaHanSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              width: 210,
              height: 210,
              decoration: ShapeDecoration(
                shape: CircleBorder(),
                gradient: gradient,
              ),
              child: Center(
                child: Text(
                  '$countDown',
                  style: DoitMainTheme.makeGoalQuestionTitleStyle.copyWith(
                    fontSize: 120.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
