import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';

enum MakeGoalNavigationAction { goNext, goBack, goTo }

class MakeGoalNavigationEvent {
  MakeGoalNavigationAction action;
}
