import 'package:do_it/src/screen/goal_timeline.dart/goal_timeline.dart';
import 'package:do_it/src/service/api/goal_service.dart';
import 'package:do_it/src/service/date_utils.dart';
import 'package:flutter/material.dart';

class DoitTimelineMainTitle extends StatelessWidget {
  const DoitTimelineMainTitle({
    Key key,
    @required this.goal,
  }) : super(key: key);

  final DoitGoalModel goal;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          goal.goalName,
          style: titleBoldTextStyle,
        ),
        SizedBox(height: 10.0),
        Text(
          getDateRange(goal),
          style: TextStyle(
            fontFamily: 'SpoqaHanSans',
            fontSize: 14.0,
            color: Colors.white.withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}
