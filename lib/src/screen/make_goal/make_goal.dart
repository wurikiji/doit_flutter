import 'package:do_it/src/screen/make_goal/bloc/progress_bloc.dart';
import 'package:do_it/src/screen/make_goal/constant/constant.dart';
import 'package:do_it/src/screen/make_goal/view/component/make_goal_app_bar.dart';
import 'package:do_it/src/screen/make_goal/view/first_page.dart';
import 'package:do_it/src/screen/make_goal/view/second_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MakeGoal extends StatelessWidget {
  final List<Widget> _pages = [
    MakeGoalFirstPage(),
    MakeGoalSecondPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      builder: (context) => MakeGoalProgressBloc(),
      child: Scaffold(
        appBar: MakeGoalAppBar(),
        body: Builder(
          builder: (builderContext) => PageView.builder(
            itemCount: numOfMakeGoalPages,
            itemBuilder: (pageContext, index) {
              return this._pages[index];
            },
            onPageChanged: (index) {
              MakeGoalProgressBloc bloc =
                  BlocProvider.of<MakeGoalProgressBloc>(builderContext);
              bloc.dispatch(
                MakeGoalProgressEvent(
                  action: MakeGoalProgressAction.setProgress,
                  pageIndex: index,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
