import 'package:do_it/src/common_view/doit_bottom_widget.dart';
import 'package:do_it/src/screen/make_goal/bloc/make_goal_bloc.dart';
import 'package:do_it/src/screen/make_goal/bloc/page_navigation_bloc.dart';
import 'package:do_it/src/screen/make_goal/bloc/progress_bloc.dart';
import 'package:do_it/src/screen/make_goal/constant/constant.dart';
import 'package:do_it/src/screen/make_goal/view/component/make_goal_app_bar.dart';
import 'package:do_it/src/screen/make_goal/view/first_page.dart';
import 'package:do_it/src/screen/make_goal/view/second_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MakeGoalWidget extends StatelessWidget {
  final List<Widget> _pages = [
    MakeGoalFirstPage(),
    MakeGoalSecondPage(),
  ];

  final PageController _pageController = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return BlocProviderTree(
      blocProviders: [
        BlocProvider<MakeGoalProgressBloc>(
          builder: (context) => MakeGoalProgressBloc(),
        ),
        BlocProvider<MakeGoalNavigationBloc>(
          builder: (context) => MakeGoalNavigationBloc(),
        ),
        BlocProvider<MakeGoalBloc>(
          builder: (context) => MakeGoalBloc(),
        ),
      ],
      child: Scaffold(
        appBar: MakeGoalAppBar(),
        bottomNavigationBar: DoitBottomAppBar(),
        floatingActionButton: DoitFloatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: Builder(
          builder: (builderContext) => BlocListener(
            bloc: BlocProvider.of<MakeGoalNavigationBloc>(builderContext),
            listener: (context, value) {
              if (value < 0) value = 0;
              if (value >= this._pages.length) value = this._pages.length - 1;

              print("Goto $value");
              this._pageController.animateToPage(
                    value,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
              MakeGoalProgressBloc bloc =
                  BlocProvider.of<MakeGoalProgressBloc>(builderContext);
              bloc.dispatch(
                MakeGoalProgressEvent(
                  action: MakeGoalProgressAction.setProgress,
                  pageIndex: value,
                ),
              );
            },
            child: PageView.builder(
              controller: this._pageController,
              itemCount: numOfMakeGoalPages,
              itemBuilder: (pageContext, index) {
                return this._pages[index];
              },
              physics: NeverScrollableScrollPhysics(),
            ),
          ),
        ),
      ),
    );
  }
}
