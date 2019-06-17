import 'package:do_it/src/color/doit_theme.dart';
import 'package:do_it/src/screen/make_goal/model/goal_model.dart';
import 'package:do_it/src/screen/make_goal/view/module/choose_category.dart';
import 'package:do_it/src/screen/make_goal/view/module/choose_confirm_method.dart';
import 'package:do_it/src/screen/make_goal/view/module/choose_period.dart';
import 'package:do_it/src/screen/make_goal/view/module/define_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class MakeGoalFirstPage extends StatelessWidget {
  final List<Widget> questionList = [
    ChooseCategory(),
    DefineTitle(),
    ChoosePeriod(),
    ChooseConfirmMethod(),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 42.0),
      child: Provider<FirstPageGoalModel>.value(
        value: FirstPageGoalModel(),
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
            Consumer<FirstPageGoalModel>(
              builder: (context, firstPageGoal, _) {
                final bool didAnswerAll =
                    firstPageGoal.numOfGoalsSet == firstPageGoal.maxNumGoals;
                return GestureDetector(
                  onTap: () {
                    if (didAnswerAll) {
                      // goto next page
                    } else {
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(milliseconds: 1000),
                          content: Text("모든 항목을 완료해주세요."),
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
                      color: Color(0x33ffffff),
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
            ),
          ],
        ),
      ),
    );
  }
}
