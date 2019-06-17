import 'package:equatable/equatable.dart';

enum GoalCategory { sport, study, hobby, saveMoney, travle, diet, etc }

int _howManyGoalsForPageOne = 3;

class FirstPageGoalModel extends Equatable {
  GoalCategory category;
  String goalTitle;
  DateTime startDate;
  DateTime endDate;
  List<int> confirmMethods;

  FirstPageGoalModel({
    this.category,
    this.confirmMethods,
    this.endDate,
    this.goalTitle,
    this.startDate,
  }) : super([category, confirmMethods, endDate, goalTitle, startDate]);

  FirstPageGoalModel copyWith({
    GoalCategory category,
    String goalTitle,
    DateTime startDate,
    DateTime endDate,
    List<int> confirmMethods,
  }) =>
      FirstPageGoalModel(
        category: category ?? this.category,
        goalTitle: goalTitle ?? this.goalTitle,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        confirmMethods: confirmMethods ?? this.confirmMethods,
      );

  int get numOfGoalsSet {
    int ret = 0;
    if (this.category != null) ret++;
    if (this.goalTitle != null) ret++;
    if (this.startDate != null) ret++;
    if (this.endDate != null) ret++;
    if (this.confirmMethods?.isNotEmpty ?? false) ret++;
    return ret;
  }

  int get maxNumGoals => _howManyGoalsForPageOne;
}
