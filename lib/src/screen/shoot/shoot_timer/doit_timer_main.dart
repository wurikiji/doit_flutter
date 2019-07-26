import 'dart:async';
import 'dart:math';

import 'package:do_it/src/screen/goal_timeline.dart/view/timeline_title.dart';
import 'package:do_it/src/screen/main/view/user_goal_card.dart';
import 'package:do_it/src/screen/make_goal/view/scond_page/project_color.dart';
import 'package:do_it/src/screen/shoot/shoot_post/doit_shoot_post.dart';
import 'package:do_it/src/screen/shoot/shoot_timer/doit_shoot_timer.dart';
import 'package:do_it/src/service/api/goal_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class DoitTimerMain extends StatefulWidget {
  DoitTimerMain({
    @required this.timer,
    @required this.goal,
  });
  final DoitGoalModel goal;
  final ShootTimerModel timer;

  @override
  _DoitTimerMainState createState() => _DoitTimerMainState();
}

class _DoitTimerMainState extends State<DoitTimerMain> {
  double percent = 0.0;
  int elapsedSeconds = 0;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        elapsedSeconds += 1;
        percent = elapsedSeconds / widget.timer.target.inSeconds;
        widget.timer.elapsed = Duration(seconds: elapsedSeconds);
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
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: projectColors[getProjectColorIndex(widget.goal.goalColor)],
          ),
          padding: const EdgeInsets.only(top: 30, bottom: 45, left: 20, right: 20),
          child: SafeArea(
            child: Column(
              children: <Widget>[
                DoitTimerAppBar(goal: widget.goal),
                SizedBox(height: 32),
                DoitTimelineMainTitle(
                  goal: widget.goal,
                ),
                SizedBox(height: 60.0),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topCenter,
                        child:
                            DoitTimerProgressIndicator(percent: percent, seconds: elapsedSeconds),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: DoitTimerPercentIndicator(percent: percent, widget: widget),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 75.0),
                DoitTimerButtonBar(
                  onPause: onPause,
                  onStart: onStart,
                  onStop: onStop,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  onStop() {
    _timer?.cancel();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => DoitShootPost(
          goal: widget.goal,
          postStatus: DoitShootPostStatus.create,
          timer: widget.timer,
        ),
      ),
    );
  }

  onStart() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        elapsedSeconds += 1;
        percent = elapsedSeconds / widget.timer.target.inSeconds;
        widget.timer.elapsed = Duration(seconds: elapsedSeconds);
      });
    });
  }

  onPause() {
    _timer?.cancel();
  }
}

class DoitTimerPercentIndicator extends StatelessWidget {
  const DoitTimerPercentIndicator({
    Key key,
    @required this.percent,
    @required this.widget,
  }) : super(key: key);

  final double percent;
  final DoitTimerMain widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: ShapeDecoration(
        shape: CircleBorder(),
        color: Colors.white,
      ),
      child: Center(
        child: Text(
          '${(percent * 100).toInt()}%',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14.0,
            color: projectColors[getProjectColorIndex(widget.goal.goalColor)].colors[1],
          ),
        ),
      ),
    );
  }
}

class DoitTimerProgressIndicator extends StatelessWidget {
  const DoitTimerProgressIndicator({
    Key key,
    @required this.percent,
    @required this.seconds,
  }) : super(key: key);

  final double percent;
  final int seconds;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: CircularPercentIndicator(
            radius: min(constraints.maxWidth, constraints.maxHeight) - 20,
            lineWidth: 9.0,
            progressColor: Colors.white,
            backgroundColor: Colors.white.withOpacity(0.15),
            percent: percent > 1.0 ? 1.0 : percent,
            circularStrokeCap: CircularStrokeCap.round,
            animation: true,
            animateFromLastPercent: true,
            animationDuration: 100,
            center: Text(
              DateFormat('HH:mm:ss').format(DateTime(0, 0, 0, 0, 0, seconds)),
              style: TextStyle(
                fontFamily: 'SpoqaHanSans',
                fontSize: 40.0,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}

class DoitTimerButtonBar extends StatefulWidget {
  const DoitTimerButtonBar({
    Key key,
    this.onPause,
    this.onStart,
    this.onStop,
  }) : super(key: key);

  final Function onStop;
  final Function onStart;
  final Function onPause;

  @override
  _DoitTimerButtonBarState createState() => _DoitTimerButtonBarState();
}

enum ButtonType { start, stop, pause }

class _DoitTimerButtonBarState extends State<DoitTimerButtonBar> {
  ButtonType rightButtonType = ButtonType.pause;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: DoitTimerButton(onTap: widget.onStop, title: '종료'),
        ),
        SizedBox(width: 12.0),
        if (rightButtonType == ButtonType.start)
          Expanded(
            child: DoitTimerButton(
              onTap: () {
                widget.onStart();
                setState(() {
                  rightButtonType = ButtonType.pause;
                });
              },
              title: '재시작',
            ),
          ),
        if (rightButtonType == ButtonType.pause)
          Expanded(
            child: DoitTimerButton(
              onTap: () {
                widget.onPause();
                setState(() {
                  rightButtonType = ButtonType.start;
                });
              },
              title: '일시정지',
            ),
          ),
      ],
    );
  }
}

class DoitTimerButton extends StatelessWidget {
  const DoitTimerButton({
    Key key,
    @required this.onTap,
    @required this.title,
  }) : super(key: key);
  final String title;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0,
      child: FlatButton(
        color: Colors.white.withOpacity(0.15),
        onPressed: onTap,
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'SpoqaHanSans',
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class DoitTimerAppBar extends StatelessWidget {
  const DoitTimerAppBar({
    Key key,
    @required this.goal,
  }) : super(key: key);

  final DoitGoalModel goal;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Spacer(),
        CardCategoryChip(
          goal: goal,
        ),
      ],
    );
  }
}
