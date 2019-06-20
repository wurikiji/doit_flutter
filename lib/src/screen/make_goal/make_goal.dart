import 'package:do_it/src/color/swatch.dart';
import 'package:do_it/src/screen/make_goal/bloc/page_navigation_bloc.dart';
import 'package:do_it/src/screen/make_goal/bloc/progress_bloc.dart';
import 'package:do_it/src/screen/make_goal/constant/constant.dart';
import 'package:do_it/src/screen/make_goal/view/component/make_goal_app_bar.dart';
import 'package:do_it/src/screen/make_goal/view/first_page.dart';
import 'package:do_it/src/screen/make_goal/view/second_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class MakeGoal extends StatelessWidget {
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
      ],
      child: Scaffold(
        appBar: MakeGoalAppBar(),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 8.0,
          child: Container(
            height: 65.0,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color(0xff282828),
                  width: 1.0,
                ),
              ),
              color: doitMainSwatch,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 20.0),
                Expanded(
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: GestureDetector(
          child: Container(
            width: 60.0,
            height: 60.0,
            decoration: ShapeDecoration(
              shape: CircleBorder(),
              gradient: LinearGradient(
                colors: [
                  Color(0xff4d90fb),
                  Color(0xff771de4),
                ],
              ),
            ),
          ),
        ),
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
