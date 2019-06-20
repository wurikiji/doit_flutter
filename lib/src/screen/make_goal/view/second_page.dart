import 'package:do_it/src/screen/make_goal/bloc/page_navigation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MakeGoalSecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final MakeGoalNavigationBloc _makeGoalNavBloc =
            BlocProvider.of<MakeGoalNavigationBloc>(context);
        _makeGoalNavBloc.dispatch(
          MakeGoalNavigationEvent(
            action: MakeGoalNavigationAction.goBack,
          ),
        );
        return false;
      },
      child: Container(
          child: Center(
        child: Text("SecondPage"),
      )),
    );
  }
}
