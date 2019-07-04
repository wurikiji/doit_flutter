import 'package:equatable/equatable.dart';

int _howManyGoalsForPageTwo = 4;
const invalidPenalty = (1 << 31);
const invalidWorkCycle = (1 << 31);
const invalidColor = (1 << 31);

class MakeGoalSecondPageModel extends Equatable {
  MakeGoalSecondPageModel({
    this.numMembers,
    this.penalty,
    this.colorIndex,
    this.workCycle,
  }) : super([numMembers, penalty, colorIndex, workCycle]);
  final int numMembers;
  final int penalty;
  final int colorIndex;
  final int workCycle;

  MakeGoalSecondPageModel copyWith({
    int numMembers,
    int penalty,
    int colorIndex,
    int workCycle,
  }) =>
      MakeGoalSecondPageModel(
        numMembers: numMembers ?? this.numMembers,
        penalty: penalty ?? this.penalty,
        colorIndex: colorIndex ?? this.colorIndex,
        workCycle: workCycle ?? this.workCycle,
      );
  int get numOfGoalsSet {
    int ret = 0;
    if ((this.numMembers ?? 0) != 0) ret++;
    if (this.penalty != null && this.penalty != invalidPenalty) ret++;
    if (this.colorIndex != null && this.colorIndex != invalidColor) ret++;
    if (this.workCycle != null && this.workCycle != invalidWorkCycle) ret++;
    return ret;
  }

  int get maxNumGoals => _howManyGoalsForPageTwo;

  bool get isAllAnswered => maxNumGoals == numOfGoalsSet;
}
