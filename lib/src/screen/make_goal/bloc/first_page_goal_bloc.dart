import 'package:bloc/bloc.dart';
import 'package:do_it/src/screen/make_goal/bloc/make_goal_bloc.dart';
import 'package:do_it/src/screen/make_goal/model/make_goal_first_page_goal_model.dart';
import 'package:equatable/equatable.dart';

enum FirstPageMakeGoalInfoAction {
  setCategory,
  setTitle,
  setStartDate,
  setEndDate,
  setUseTimer,
}

class FirstPageMakeGoalInfoEvent<T> extends Equatable {
  final FirstPageMakeGoalInfoAction action;
  final T data;
  FirstPageMakeGoalInfoEvent({
    this.action,
    this.data,
  }) : super([action, data]);
}

class FirstPageMakeGoalInfoSnapshot extends Equatable {
  FirstPageGoalModel goal;
  FirstPageMakeGoalInfoSnapshot({
    this.goal,
  }) : super([goal]);
}

class FirstPageMakeGoalBloc
    extends Bloc<FirstPageMakeGoalInfoEvent, FirstPageMakeGoalInfoSnapshot> {
  FirstPageMakeGoalBloc({this.makeGoalBloc});

  final MakeGoalBloc makeGoalBloc;
  @override
  FirstPageMakeGoalInfoSnapshot get initialState =>
      FirstPageMakeGoalInfoSnapshot(goal: FirstPageGoalModel());

  @override
  Stream<FirstPageMakeGoalInfoSnapshot> mapEventToState(
      FirstPageMakeGoalInfoEvent event) async* {
    switch (event.action) {
      case FirstPageMakeGoalInfoAction.setCategory:
        yield FirstPageMakeGoalInfoSnapshot(
          goal: currentState.goal.copyWith(category: event.data),
        );
        break;
      case FirstPageMakeGoalInfoAction.setTitle:
        yield FirstPageMakeGoalInfoSnapshot(
          goal: currentState.goal.copyWith(goalTitle: event.data),
        );
        break;
      case FirstPageMakeGoalInfoAction.setStartDate:
        yield FirstPageMakeGoalInfoSnapshot(
          goal: currentState.goal.copyWith(startDate: event.data),
        );
        break;
      case FirstPageMakeGoalInfoAction.setEndDate:
        yield FirstPageMakeGoalInfoSnapshot(
          goal: currentState.goal.copyWith(endDate: event.data),
        );
        break;
      case FirstPageMakeGoalInfoAction.setUseTimer:
        yield FirstPageMakeGoalInfoSnapshot(
          goal: currentState.goal.copyWith(useTimer: event.data),
        );
        break;
    }
  }
}
