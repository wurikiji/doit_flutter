import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';

enum MakeGoalNavigationAction { goNext, goBack, goTo }

class MakeGoalNavigationEvent {
  MakeGoalNavigationAction action;
  int pageNo;
  MakeGoalNavigationEvent({
    this.action = MakeGoalNavigationAction.goNext,
    this.pageNo = 0,
  });
}

class MakeGoalNavigationBloc extends Bloc<MakeGoalNavigationEvent, int> {
  @override
  int get initialState => 0;

  @override
  Stream<int> mapEventToState(MakeGoalNavigationEvent event) async* {
    switch (event.action) {
      case MakeGoalNavigationAction.goNext:
        yield currentState + 1;
        break;
      case MakeGoalNavigationAction.goBack:
        yield currentState - 1;
        break;
      case MakeGoalNavigationAction.goTo:
        yield event.pageNo;
        break;
    }
  }
}
