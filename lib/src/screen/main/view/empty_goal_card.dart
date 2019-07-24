import 'dart:async';

import 'package:do_it/src/screen/main/common/goal_card.dart';
import 'package:do_it/src/screen/make_goal/make_goal.dart';
import 'package:do_it/src/model/make_goal_model.dart';
import 'package:do_it/src/screen/make_goal/view/scond_page/project_color.dart';
import 'package:do_it/src/service/api/category_service.dart';
import 'package:do_it/src/service/api/goal_service.dart';
import 'package:do_it/src/service/api/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmptyGoalCard extends StatelessWidget {
  const EmptyGoalCard({
    Key key,
  }) : super(key: key);

  String getColorsString(List<Color> colors) {
    String ret = '#${colors[0].value.toRadixString(16)}:#${colors[1].value.toRadixString(16)}';
    print(ret);
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final MakeGoalModel model = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MakeGoalWidget(),
          ),
        );
        if (model != null) {
          await DoitGoalService.createGoal(
            DoitGoalModel(
              categoryName: CategoryService.getCategoryName(model.firstPage.category),
              endDate: model.firstPage.endDate,
              goalColor: getColorsString(projectColors[model.secondPage.colorIndex].colors),
              goalId: null,
              goalName: model.firstPage.goalTitle,
              memberCount: model.secondPage.numMembers,
              penalty: model.secondPage.penalty,
              progressRate: null,
              repeatType: model.secondPage.repeatType,
              repeatDays: model.secondPage.workCycle,
              startDate: model.firstPage.startDate,
              useTimer: model.firstPage.useTimer,
            ),
          );
          await DoitGoalService.getGoalsFromServer(context);
        }
      },
      child: DoitMainCard(
        child: Column(
          children: <Widget>[
            SizedBox(height: 128.0),
            Icon(
              Icons.add,
              size: 60.0,
            ),
            Text(
              "Make Goal",
              style: Theme.of(context).textTheme.title.copyWith(
                    fontSize: 24.0,
                    height: 30.0 / 24.0,
                    letterSpacing: 0.15,
                  ),
            ),
            Text(
              "새로운 목표를 만들어 볼까요?",
              style: Theme.of(context).textTheme.body1.copyWith(
                    fontSize: 14.0,
                    height: 22 / 14.0,
                    letterSpacing: 0.1,
                  ),
            ),
          ],
        ),
        gradient: LinearGradient(
          colors: [
            Color(0xff28292a),
            Color(0xff28292a),
          ],
        ),
      ),
    );
  }
}
