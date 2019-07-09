import 'package:do_it/src/screen/main/common/goal_card.dart';
import 'package:do_it/src/screen/make_goal/make_goal.dart';
import 'package:do_it/src/model/make_goal_model.dart';
import 'package:do_it/src/service/api/goal_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmptyGoalCard extends StatelessWidget {
  const EmptyGoalCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GoalService>(builder: (context, value, child) {
      return GestureDetector(
        onTap: () async {
          final MakeGoalModel model = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MakeGoalWidget(),
            ),
          );
          if (model != null) {
            value.addGoal(model);
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
    });
  }
}
