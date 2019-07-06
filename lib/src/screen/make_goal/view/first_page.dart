import 'package:do_it/src/color/doit_theme.dart';
import 'package:do_it/src/screen/make_goal/bloc/first_page_goal_bloc.dart';
import 'package:do_it/src/screen/make_goal/bloc/make_goal_bloc.dart';
import 'package:do_it/src/screen/make_goal/bloc/page_navigation_bloc.dart';
import 'package:do_it/src/screen/make_goal/view/first_page/choose_category.dart';
import 'package:do_it/src/screen/make_goal/view/first_page/choose_confirm_method.dart';
import 'package:do_it/src/screen/make_goal/view/first_page/choose_period.dart';
import 'package:do_it/src/screen/make_goal/view/first_page/define_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MakeGoalFirstPage extends StatelessWidget {
  final List<Widget> questionList = [
    ChooseCategory(),
    DefineTitle(),
    ChoosePeriod(),
    ChooseConfirmMethod(),
    MakeGoalNextStepButton(),
  ];
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 52.0),
        child: BlocProvider<FirstPageMakeGoalBloc>(
          builder: (context) => FirstPageMakeGoalBloc(
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
            ],
          ),
        ),
      ),
    );
  }
}

class MakeGoalNextStepButton extends StatelessWidget {
  const MakeGoalNextStepButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<FirstPageMakeGoalBloc>(context),
      builder: (context, FirstPageMakeGoalInfoSnapshot snapshot) {
        final bool didAnswerAll = snapshot?.goal?.isAllAnswered ?? false;
        print(snapshot?.goal?.numOfGoalsSet);
        return GestureDetector(
          onTap: () {
            if (didAnswerAll) {
              final MakeGoalNavigationBloc _makeGoalNavBloc =
                  BlocProvider.of<MakeGoalNavigationBloc>(context);
              _makeGoalNavBloc.dispatch(
                MakeGoalNavigationEvent(
                  action: MakeGoalNavigationAction.goNext,
                ),
              );
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
                colors: [
                  didAnswerAll ? Color(0xff4d90fb) : Color(0x33ffffff),
                  didAnswerAll ? Color(0xff771de4) : Color(0x33ffffff),
                ],
              ),
            ),
            child: Center(
              child: Text(
                "다음",
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
