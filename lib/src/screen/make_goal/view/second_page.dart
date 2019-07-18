import 'dart:ui';

import 'package:do_it/src/color/doit_theme.dart';
import 'package:do_it/src/screen/make_goal/bloc/page_navigation_bloc.dart';
import 'package:do_it/src/screen/make_goal/bloc/second_page_goal_bloc.dart';
import 'package:do_it/src/model/make_goal_model.dart';
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
    MakeGoalCompleteButton(),
  ];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final MakeGoalNavigationBloc _makeGoalNavBloc = BlocProvider.of<MakeGoalNavigationBloc>(context);
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
                      separatorBuilder: (context, index) => SizedBox(height: 50.0),
                      itemCount: this.questionList.length,
                      itemBuilder: (context, index) => this.questionList[index],
                      physics: ClampingScrollPhysics(),
                    ),
                  ),
                ),
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
                barrierDismissible: true,
                barrierColor: Colors.black.withAlpha(0x99),
                barrierLabel: 'Make goal succeeded',
                transitionBuilder: (context, animation, secondaryAnimation, child) {
                  return child;
                },
                transitionDuration: Duration(milliseconds: 300),
                pageBuilder: (context, animation, secondAnimation) {
                  return SuccessModal();
                },
              );
              final MakeGoalModel goal = MakeGoalBloc.getBloc(context).goalState.data;
              print(goal);
              Navigator.of(context).pop(goal);
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
                begin: Alignment.topLeft,
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
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 27),
        child: Center(
          child: Opacity(
            opacity: 1.00,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 306.0,
                height: 236.0,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  color: Color(0xff222222),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 40.0,
                    horizontal: 55.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Success!",
                        style: DoitMainTheme.makeGoalQuestionTitleStyle.copyWith(fontSize: 30.0),
                      ),
                      SizedBox(height: 2.0),
                      Text(
                        '프로젝트 생성이 완료되었습니다.\n'
                        '이제 두잇에서 목표를 이뤄보세요!',
                        style: DoitMainTheme.makeGoalUserInputTextStyle.copyWith(fontSize: 14.0),
                      ),
                      Spacer(),
                      RaisedButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        shape: StadiumBorder(),
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 28.0,
                          vertical: 15.0,
                        ),
                        child: Text(
                          "프로젝트 홈 가기",
                          style: DoitMainTheme.makeGoalQuestionTitleStyle.copyWith(
                            fontSize: 14.0,
                            color: Color(0xff222222),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
