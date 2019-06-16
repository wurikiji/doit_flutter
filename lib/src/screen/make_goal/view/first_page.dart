import 'package:do_it/src/color/doit_theme.dart';
import 'package:do_it/src/screen/make_goal/view/module/choose_category.dart';
import 'package:do_it/src/screen/make_goal/view/module/choose_confirm_method.dart';
import 'package:do_it/src/screen/make_goal/view/module/choose_period.dart';
import 'package:do_it/src/screen/make_goal/view/module/define_title.dart';
import 'package:flutter/material.dart';

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
              ),
            ),
          ),
          GestureDetector(
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
                  style: DoitMainTheme.makeGoalNextButtonDisabledTextStyle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
