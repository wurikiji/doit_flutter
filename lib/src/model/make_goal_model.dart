import 'package:do_it/src/screen/make_goal/model/make_goal_first_page_goal_model.dart';
import 'package:do_it/src/screen/make_goal/model/make_goal_second_page_model.dart';
import 'package:equatable/equatable.dart';

class MakeGoalModel extends Equatable {
  MakeGoalModel({
    this.firstPage,
    this.secondPage,
  });
  MakeGoalFirstPageModel firstPage;
  MakeGoalSecondPageModel secondPage;
}

class DoitGoal {
  DoitGoal({
    this.goal,
    this.userName,
  });
  final MakeGoalModel goal;
  final String userName;
}
