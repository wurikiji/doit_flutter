import 'dart:async';

import 'package:do_it/src/model/make_goal_model.dart';
import 'package:do_it/src/model/user_model.dart';
import 'package:do_it/src/screen/make_goal/model/make_goal_first_page_goal_model.dart';
import 'package:do_it/src/screen/make_goal/model/make_goal_second_page_model.dart';

StreamController<DoitGoal> goalsInServer = StreamController<DoitGoal>.broadcast();
List<DoitGoal> finishedGoals = <DoitGoal>[
  DoitGoal(
    goal: MakeGoalModel(
      firstPage: MakeGoalFirstPageModel(
        category: GoalCategory.study,
        endDate: DateTime.now().subtract(Duration(days: 1)),
        startDate: DateTime.now().subtract(Duration(days: 22)),
        goalTitle: 'ended',
        useTimer: false,
      ),
      secondPage: MakeGoalSecondPageModel(
        colorIndex: 4,
        numMembers: 3,
        penalty: 10000,
        workCycle: 4,
      ),
    ),
  ),
];

List<DoitGoal> inProgressGoal = <DoitGoal>[
  DoitGoal(
    goal: MakeGoalModel(
      firstPage: MakeGoalFirstPageModel(
        category: GoalCategory.diet,
        endDate: DateTime.now().add(Duration(days: 10)),
        startDate: DateTime.now(),
        goalTitle: 'hihi',
        useTimer: false,
      ),
      secondPage: MakeGoalSecondPageModel(
        colorIndex: 0,
        numMembers: 2,
        penalty: 10000,
        workCycle: 2,
      ),
    ),
  ),
  DoitGoal(
    goal: MakeGoalModel(
      firstPage: MakeGoalFirstPageModel(
        category: GoalCategory.hobby,
        endDate: DateTime.now().add(Duration(days: 12)),
        startDate: DateTime.now().add(Duration(days: 2)),
        goalTitle: 'hihi2',
        useTimer: false,
      ),
      secondPage: MakeGoalSecondPageModel(
        colorIndex: 1,
        numMembers: 2,
        penalty: 5000,
        workCycle: 3,
      ),
    ),
  ),
];

class GoalService {
  GoalService({
    this.user,
  }) {
    // goalsInServer.stream.listen((data) => hi.add(data));
  }

  final UserModel user;

  Stream<DoitGoal> get goals => goalsInServer.stream;

  addGoal(DoitGoal goal) async {
    goalsInServer.add(goal);
  }
}
