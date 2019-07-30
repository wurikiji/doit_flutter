import 'package:do_it/src/screen/goal_timeline.dart/view/timeline_info.dart';
import 'package:do_it/src/screen/goal_timeline.dart/view/timeline_title.dart';
import 'package:do_it/src/screen/goal_timeline.dart/view/timeline_appbar.dart';
import 'package:do_it/src/screen/goal_timeline.dart/view/timeline_ranking_list.dart';
import 'package:do_it/src/screen/main/view/user_goal_card.dart';
import 'package:do_it/src/screen/make_goal/view/scond_page/project_color.dart';
import 'package:do_it/src/service/api/goal_service.dart';
import 'package:flutter/material.dart';

class DoitTimelineBackdrop extends StatelessWidget {
  const DoitTimelineBackdrop({
    Key key,
    @required this.goal,
  }) : super(key: key);

  final DoitGoalModel goal;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 60.0),
      decoration: BoxDecoration(
        gradient: projectColors[getProjectColorIndex(goal.goalColor)],
      ),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            DoitTimeLineAppBar(goal: goal),
            SizedBox(height: 10.0),
            DoitTimelineMainTitle(goal: goal),
            SizedBox(height: 20.0),
            DoitTimelineInfo(goal: goal),
            SizedBox(height: 20.0),
            Expanded(
              child: DoitTimelineRanking(
                goal: goal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
