import 'package:bloc/bloc.dart';
import 'package:do_it/src/screen/make_goal/constant/constant.dart';
import 'package:equatable/equatable.dart';

enum MakeGoalProgressAction { setProgress }

class MakeGoalProgressEvent extends Equatable {
  MakeGoalProgressAction action;
  int pageIndex;
  MakeGoalProgressEvent({this.action, this.pageIndex})
      : super([action, pageIndex]);
}

class MakeGoalProgressSnapshot extends Equatable {
  double progress;
  MakeGoalProgressSnapshot({this.progress}) : super([progress]);
}

class MakeGoalProgressBloc
    extends Bloc<MakeGoalProgressEvent, MakeGoalProgressSnapshot> {
  @override
  MakeGoalProgressSnapshot get initialState =>
      MakeGoalProgressSnapshot(progress: 1 / numOfMakeGoalPages);

  @override
  Stream<MakeGoalProgressSnapshot> mapEventToState(
      MakeGoalProgressEvent event) async* {
    if (event.action == MakeGoalProgressAction.setProgress) {
      yield MakeGoalProgressSnapshot(
          progress: (event.pageIndex + 1) / numOfMakeGoalPages);
    } else {
      throw Exception('Undefined MakeGoalProgressAction ${event.action}');
    }
  }
}
