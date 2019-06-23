import 'package:bloc/bloc.dart';
import 'package:do_it/src/screen/make_goal/bloc/make_goal_bloc.dart';
import 'package:equatable/equatable.dart';

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

class MakeGoalSecondPageState<T> extends Equatable {
  MakeGoalSecondPageState({this.reaction, this.data}) : super([reaction, data]);
  final MakeGoalSecondPageReaction reaction;
  final T data;
  bool hasData() {
    return this.reaction != null && this.data != null;
  }
}

class MakeGoalSecondPageBloc
    extends Bloc<MakeGoalSecondPageEvent, MakeGoalSecondPageState> {
  MakeGoalSecondPageBloc({this.makeGoalBloc});

  final MakeGoalBloc makeGoalBloc;
  @override
  MakeGoalSecondPageState get initialState => MakeGoalSecondPageState();

  @override
  Stream<MakeGoalSecondPageState> mapEventToState(
      MakeGoalSecondPageEvent event) {
    return null;
  }
}
