import 'dart:math';

import 'package:do_it/src/service/api/goal_service.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CardProgressIndicator extends StatelessWidget {
  const CardProgressIndicator({
    Key key,
    @required this.goal,
  }) : super(key: key);

  final DoitGoalModel goal;

  @override
  Widget build(BuildContext context) {
    print('Percent: ${goal.progressRate}');
    return LayoutBuilder(builder: (context, constraints) {
      double diameter = min(constraints.maxWidth, constraints.maxHeight) - 10.0;
      double progress = goal.progressRate / 100.0 > 1.0 ? 1.0 : goal.progressRate / 100.0;
      return Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: <Widget>[
          CircularPercentIndicator(
            radius: diameter,
            progressColor: Colors.white,
            circularStrokeCap: CircularStrokeCap.round,
            backgroundColor: Colors.white.withOpacity(0.15),
            lineWidth: 9.0,
            percent: progress,
            animation: true,
            animateFromLastPercent: true,
            animationDuration: 500,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(
                  getDday(),
                  style: TextStyle(
                    fontFamily: 'SpoqaHanSans',
                    fontSize: 12.0,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "${progress * 100}%",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 34.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xfffffff0),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  String getDday() {
    DateTime now = DateTime.now();
    return now.isBefore(goal.startDate)
        ? "D - ${goal.startDate.difference(now.subtract(Duration(minutes: 60 * 24 - 1))).inDays}"
        : '현재 진행률';
  }
}
