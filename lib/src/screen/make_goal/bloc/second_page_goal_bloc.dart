import 'package:bloc/bloc.dart';
import 'package:do_it/src/screen/make_goal/bloc/make_goal_bloc.dart';
import 'package:do_it/src/screen/make_goal/model/make_goal_second_page_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum MakeGoalSecondPageAction {
  setWorkCycle,
  setNumMembers,
  setPenalty,
  setProjectColor,
}

class MakeGoalSecondPageEvent<T> extends Equatable {
  MakeGoalSecondPageEvent({
    this.action,
    this.data,
  }) : super([action, data]);
  final MakeGoalSecondPageAction action;
  final T data;
  bool hasData() {
    return this.action != null && this.data != null;
  }
}

enum MakeGoalSecondPageReaction { success }

class MakeGoalSecondPageState extends Equatable {
  MakeGoalSecondPageState({this.reaction, this.data}) : super([reaction, data]);
  final MakeGoalSecondPageReaction reaction;
  final MakeGoalSecondPageModel data;
  bool hasData() {
    return this.reaction != null && this.data != null;
  }
}

class MakeGoalSecondPageBloc extends Bloc<MakeGoalSecondPageEvent, MakeGoalSecondPageState> {
  MakeGoalSecondPageBloc({this.makeGoalBloc});

  final MakeGoalBloc makeGoalBloc;
  @override
  MakeGoalSecondPageState get initialState => MakeGoalSecondPageState(
        data: makeGoalBloc.goalState.data.secondPage,
        reaction: MakeGoalSecondPageReaction.success,
      );

  @override
  Stream<MakeGoalSecondPageState> mapEventToState(MakeGoalSecondPageEvent event) async* {
    var nextModel = currentState.data;
    switch (event.action) {
      case MakeGoalSecondPageAction.setNumMembers:
        nextModel = nextModel.copyWith(numMembers: event.data);
        break;
      case MakeGoalSecondPageAction.setPenalty:
        nextModel = nextModel.copyWith(penalty: event.data);
        break;
      case MakeGoalSecondPageAction.setProjectColor:
        nextModel = nextModel.copyWith(colorIndex: event.data);
        break;
      case MakeGoalSecondPageAction.setWorkCycle:
        nextModel = nextModel.copyWith(workCycle: event.data);
        break;
    }
    makeGoalBloc.dispatch(
      MakeGoalEvent(
        action: MakeGoalAction.setSecondPageGoal,
        data: nextModel,
      ),
    );
    yield MakeGoalSecondPageState(
      data: nextModel,
      reaction: MakeGoalSecondPageReaction.success,
    );
  }

  static MakeGoalSecondPageBloc getBloc(BuildContext context) => BlocProvider.of<MakeGoalSecondPageBloc>(context);
}
