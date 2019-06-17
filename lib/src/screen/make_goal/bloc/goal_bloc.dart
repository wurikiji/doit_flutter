import 'package:bloc/bloc.dart';

enum MakeGoalInfoAction { setCategory, setTitle, setPeriod, setConfirmMethod }

class MakeGoalInfoEvent {
  MakeGoalInfoAction action;
}

class MakeGoalInfoSnapshot {}
