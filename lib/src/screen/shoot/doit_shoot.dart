import 'package:do_it/src/model/make_goal_model.dart';
import 'package:do_it/src/screen/shoot/shoot_post/doit_shoot_post.dart';
import 'package:do_it/src/screen/shoot/shoot_timer/doit_shoot_timer.dart';
import 'package:do_it/src/service/api/goal_service.dart';
import 'package:do_it/src/service/date_utils.dart';
import 'package:flutter/material.dart';

class DoitShoot extends StatelessWidget {
  const DoitShoot({
    Key key,
    this.goal,
  }) : super(key: key);

  final DoitGoalModel goal;

  @override
  Widget build(BuildContext context) {
    if (goal != null) {
      if (goal.useTimer) {
        return DoitShootTimer(
          goal: goal,
        );
      } else {
        return DoitShootPost(
          goal: goal,
          postStatus: DoitShootPostStatus.create,
        );
      }
    }
    List<DoitGoalModel> startedGoals = DoitGoalService.goalList
        .where(
          (goal) => isStarted(goal) && !isEnded(goal),
        )
        .toList();
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Image.asset('assets/images/outline_clear_24_px.png'),
        ),
        centerTitle: true,
        title: Text("Shoot!"),
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 90.0),
        itemCount: startedGoals.length,
        separatorBuilder: (context, index) => SizedBox(height: 60.0),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => DoitShootTimer(goal: startedGoals[index]),
                ),
              );
            },
            child: Center(
              child: Text(
                startedGoals[index].goalName,
                style: const TextStyle(
                  color: const Color(0xffffffff),
                  fontWeight: FontWeight.w700,
                  fontFamily: "SpoqaHanSans",
                  fontStyle: FontStyle.normal,
                  fontSize: 25.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      ),
    );
  }
}
