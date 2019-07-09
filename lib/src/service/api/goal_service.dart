import 'dart:async';
import 'dart:io';

import 'package:do_it/src/model/make_goal_model.dart';
import 'package:do_it/src/model/user_model.dart';

StreamController<MakeGoalModel> goalsInServer = StreamController<MakeGoalModel>.broadcast();

class GoalService {
  GoalService({
    this.user,
  });
  final UserModel user;

  Stream<MakeGoalModel> get goals => goalsInServer.stream;
  // Stream<MakeGoalModel> getGoals() async* {}

  addGoal(MakeGoalModel goal) async {
    goalsInServer.add(goal);
  }
}
