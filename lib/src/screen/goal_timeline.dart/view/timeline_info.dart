import 'package:do_it/src/screen/goal_timeline.dart/goal_timeline.dart';
import 'package:do_it/src/service/api/goal_service.dart';
import 'package:do_it/src/service/date_utils.dart';
import 'package:flutter/material.dart';

class DoitTimelineInfo extends StatelessWidget {
  const DoitTimelineInfo({
    Key key,
    @required this.goal,
  }) : super(key: key);

  final DoitGoalModel goal;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        color: Colors.white.withOpacity(0.15),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "D - ${getDdayToEnd(goal)}",
                  style: titleBoldTextStyle,
                ),
                SizedBox(height: 8.0),
                Text(
                  "남은 기간",
                  style: descTextStyle.copyWith(
                    color: Colors.white.withOpacity(0.91),
                  ),
                ),
              ],
            ),
          ),
          VerticalDivider(
            color: Colors.white.withOpacity(0.5),
            width: 1.0,
            indent: 16.0,
            endIndent: 16.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  goal.penalty.toString(),
                  style: titleBoldTextStyle,
                ),
                SizedBox(height: 8.0),
                Text(
                  '전체 금액',
                  style: descTextStyle.copyWith(
                    color: Colors.white.withOpacity(0.91),
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
