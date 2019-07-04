import 'dart:ui';

import 'package:do_it/src/color/doit_theme.dart';
import 'package:do_it/src/screen/make_goal/bloc/page_navigation_bloc.dart';
import 'package:do_it/src/screen/make_goal/bloc/second_page_goal_bloc.dart';
import 'package:do_it/src/screen/make_goal/view/scond_page/how_many_people.dart';
import 'package:do_it/src/screen/make_goal/view/scond_page/how_many_times.dart';
import 'package:do_it/src/screen/make_goal/view/scond_page/how_much_penalty.dart';
import 'package:do_it/src/screen/make_goal/view/scond_page/project_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:do_it/src/screen/make_goal/bloc/make_goal_bloc.dart';

class MakeGoalSecondPage extends StatelessWidget {
  final List questionList = [
    HowManyTimes(),
    HowManyPeople(),
    HowMuchPenalty(),
    ProjectColor(),
  ];
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
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 52.0),
          child: BlocProvider<MakeGoalSecondPageBloc>(
            builder: (context) => MakeGoalSecondPageBloc(
              makeGoalBloc: BlocProvider.of<MakeGoalBloc>(context),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 50.0),
                      itemCount: this.questionList.length,
                      itemBuilder: (context, index) => this.questionList[index],
                      physics: ClampingScrollPhysics(),
                    ),
                  ),
                ),
                MakeGoalCompleteButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MakeGoalCompleteButton extends StatelessWidget {
  const MakeGoalCompleteButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<MakeGoalSecondPageBloc>(context),
      builder: (context, MakeGoalSecondPageState snapshot) {
        final bool didAnswerAll = (snapshot?.data?.isAllAnswered ?? false);
        return GestureDetector(
          onTap: () async {
            if (didAnswerAll) {
              await showGeneralDialog(
                context: context,
                barrierDismissible: false,
                barrierColor: Colors.black.withAlpha(0x99),
                barrierLabel: 'Make goal succeeded',
                transitionBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return child;
                },
                transitionDuration: Duration(milliseconds: 300),
                pageBuilder: (context, animation, secondAnimation) {
                  return BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Center(
                      child: SuccessModal(),
                    ),
                  );
                },
              );
              // TODO : 서버에 저장
              Navigator.of(context).pop();
            } else {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(milliseconds: 1000),
                  content: Text(
                    "모든 항목을 완료해주세요.",
                    style: DoitMainTheme.makeGoalQuestionTitleStyle,
                  ),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            height: 50.0,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              gradient: LinearGradient(
                end: Alignment.bottomRight,
                colors: [
                  didAnswerAll ? Color(0xff4d90fb) : Color(0x33ffffff),
                  didAnswerAll ? Color(0xff771de4) : Color(0x33ffffff),
                ],
              ),
            ),
            child: Center(
              child: Text(
                "골 생성하기 ",
                style: didAnswerAll
                    ? DoitMainTheme.makeGoalNextButtonEnabledTextStyle
                    : DoitMainTheme.makeGoalNextButtonDisabledTextStyle,
              ),
            ),
          ),
        );
      },
    );
  }
}

class SuccessModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 27),
      child: AspectRatio(
        aspectRatio: 306 / 236,
        child: Opacity(
          opacity: 0.90,
          child: Container(
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              gradient: LinearGradient(
                colors: [
                  Color(0xff5188fa),
                  Color(0xff7526e6),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
