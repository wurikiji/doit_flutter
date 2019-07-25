import 'package:do_it/src/service/api/goal_service.dart';
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
    this.repeatType,
  }) : super([numMembers, penalty, colorIndex, workCycle]);
  final int numMembers;
  final int penalty;
  final int colorIndex;
  final int workCycle;
  final DoitGoalRepeatType repeatType;

  MakeGoalSecondPageModel copyWith({
    int numMembers,
    int penalty,
    int colorIndex,
    int workCycle,
    DoitGoalRepeatType repeatType,
  }) =>
      MakeGoalSecondPageModel(
        numMembers: numMembers ?? this.numMembers,
        penalty: penalty ?? this.penalty,
        colorIndex: colorIndex ?? this.colorIndex,
        workCycle: workCycle ?? this.workCycle,
        repeatType: repeatType ?? this.repeatType,
      );
  int get numOfGoalsSet {
    int ret = 0;
    if ((this.numMembers ?? 0) != 0) ret++;
    if (this.penalty != null && this.penalty != invalidPenalty) ret++;
    if (this.colorIndex != null && this.colorIndex != invalidColor) ret++;
    if ((this.repeatType ?? DoitGoalRepeatType.invalid) != DoitGoalRepeatType.invalid) {
      if (this.repeatType == DoitGoalRepeatType.everyDay)
        ret++;
      else if ((this.workCycle ?? 0) != 0) ret++;
    }
    return ret;
  }

  int get maxNumGoals => _howManyGoalsForPageTwo;

  bool get isAllAnswered => maxNumGoals == numOfGoalsSet;
}
