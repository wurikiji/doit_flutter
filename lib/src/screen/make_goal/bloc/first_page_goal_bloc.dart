import 'package:bloc/bloc.dart';
import 'package:do_it/src/screen/make_goal/bloc/make_goal_bloc.dart';
import 'package:do_it/src/screen/make_goal/model/make_goal_first_page_goal_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  MakeGoalFirstPageModel goal;
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
      FirstPageMakeGoalInfoSnapshot(
        goal: makeGoalBloc.goalState.data.firstPage,
      );

  @override
  Stream<FirstPageMakeGoalInfoSnapshot> mapEventToState(
      FirstPageMakeGoalInfoEvent event) async* {
    MakeGoalFirstPageModel nextState;
    switch (event.action) {
      case FirstPageMakeGoalInfoAction.setCategory:
        nextState = currentState.goal.copyWith(category: event.data);
        break;
      case FirstPageMakeGoalInfoAction.setTitle:
        nextState = currentState.goal.copyWith(goalTitle: event.data);
        break;
      case FirstPageMakeGoalInfoAction.setStartDate:
        nextState = currentState.goal.copyWith(startDate: event.data);
        break;
      case FirstPageMakeGoalInfoAction.setEndDate:
        nextState = currentState.goal.copyWith(endDate: event.data);
        break;
      case FirstPageMakeGoalInfoAction.setUseTimer:
        nextState = currentState.goal.copyWith(useTimer: event.data);
        break;
    }
    makeGoalBloc.dispatch(
      MakeGoalEvent(
        action: MakeGoalAction.setFirstPageGoal,
        data: nextState,
      ),
    );
    yield FirstPageMakeGoalInfoSnapshot(
      goal: nextState,
    );
  }

  static getBloc(BuildContext context) =>
      BlocProvider.of<FirstPageMakeGoalBloc>(context);
}
