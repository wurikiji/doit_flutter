import 'package:equatable/equatable.dart';

enum GoalCategory { sport, study, hobby, saveMoney, travel, diet, etc, none }

const int _howManyGoalsForPageOne = 5;

class MakeGoalFirstPageModel extends Equatable {
  GoalCategory category;
  String goalTitle;
  DateTime startDate;
  DateTime endDate;
  bool useTimer;

  MakeGoalFirstPageModel({
    this.category,
    this.useTimer = false,
    this.endDate,
    this.goalTitle,
    this.startDate,
  }) : super([category, useTimer, endDate, goalTitle, startDate]);

  MakeGoalFirstPageModel copyWith({
    GoalCategory category,
    String goalTitle,
    DateTime startDate,
    DateTime endDate,
    bool useTimer,
  }) =>
      MakeGoalFirstPageModel(
        category: category ?? this.category,
        goalTitle: goalTitle ?? this.goalTitle,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        useTimer: useTimer ?? this.useTimer,
      );

  int get numOfGoalsSet {
    int ret = 0;
    if ((this.category ?? GoalCategory.none) != GoalCategory.none) ret++;
    if ((this.goalTitle?.length ?? 0) > 0) ret++;
    if (this.startDate != null) ret++;
    if (this.endDate != null) ret++;
    if (this.useTimer != null) ret++;
    return ret;
  }

  int get maxNumGoals => _howManyGoalsForPageOne;

  bool get isAllAnswered => maxNumGoals == numOfGoalsSet;
}
