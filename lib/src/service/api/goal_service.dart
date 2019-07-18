import 'dart:async';
import 'dart:io';

import 'package:do_it/src/model/make_goal_model.dart';
import 'package:do_it/src/model/user_model.dart';
import 'package:flutter/widgets.dart';

StreamController<MakeGoalModel> goalsInServer = StreamController<MakeGoalModel>.broadcast();
List hi = List<MakeGoalModel>();

class GoalService {
  GoalService({
    this.user,
  }) {
    goalsInServer.stream.listen((data) => hi.add(data));
  }

  final UserModel user;

  Stream<MakeGoalModel> get goals => goalsInServer.stream;

  addGoal(MakeGoalModel goal) async {
    goalsInServer.add(goal);
  }
}
