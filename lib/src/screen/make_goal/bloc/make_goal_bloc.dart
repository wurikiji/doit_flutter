import 'package:bloc/bloc.dart';
import 'package:do_it/src/screen/make_goal/model/make_goal_first_page_goal_model.dart';
import 'package:do_it/src/screen/make_goal/model/make_goal_model.dart';
import 'package:do_it/src/screen/make_goal/model/make_goal_second_page_model.dart';
import 'package:equatable/equatable.dart';

enum MakeGoalAction { setFirstPageGoal, setSecondPageGoal }

class MakeGoalEvent<T> extends Equatable {
  MakeGoalEvent({
    this.action,
    this.data,
  }) : super([action, data]);
  final MakeGoalAction action;
  final T data;
  bool hasData() {
    return this.action != null && this.data != null;
  }
}

enum MakeGoalReaction { success }

class MakeGoalState extends Equatable {
  MakeGoalState({this.reaction, this.data}) : super([reaction, data]);
  final MakeGoalReaction reaction;
  final MakeGoalModel data;
  bool hasData() {
    return this.reaction != null && this.data != null;
  }
}

class MakeGoalBloc extends Bloc<MakeGoalEvent, MakeGoalState> {
  MakeGoalBloc() {
    this.goalState = MakeGoalState(
      data: MakeGoalModel(
        firstPage: MakeGoalFirstPageModel(),
        secondPage: MakeGoalSecondPageModel(),
      ),
    );
  }
  MakeGoalState goalState;
  @override
  MakeGoalState get initialState => goalState;
  @override
  Stream<MakeGoalState> mapEventToState(MakeGoalEvent event) async* {
    switch (event.action) {
      case MakeGoalAction.setFirstPageGoal:
        this.goalState.data.firstPage = event.data;
        break;
      case MakeGoalAction.setSecondPageGoal:
        this.goalState.data.secondPage = event.data;
        break;
    }
  }
}
