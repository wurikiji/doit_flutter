import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

enum MakeGoalAction { calculate }

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

class MakeGoalState<T> extends Equatable {
  MakeGoalState({this.reaction, this.data}) : super([reaction, data]);
  final MakeGoalReaction reaction;
  final T data;
  bool hasData() {
    return this.reaction != null && this.data != null;
  }
}

class MakeGoalBloc extends Bloc<MakeGoalEvent, MakeGoalState> {
  @override
  MakeGoalState get initialState => MakeGoalState();

  @override
  Stream<MakeGoalState> mapEventToState(MakeGoalEvent event) {
    return null;
  }
}
