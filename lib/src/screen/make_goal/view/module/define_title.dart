import 'package:do_it/src/color/doit_theme.dart';
import 'package:do_it/src/screen/make_goal/view/component/question_scaffold.dart';
import 'package:flutter/material.dart';

class DefineTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return QuestionScaffold(
      title: '프로젝트의 상세 타이틀을 적어주세요.',
      children: <Widget>[
        TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            filled: true,
            fillColor: Color(0xff2b2b2b),
            hintText: '주 3회 이상 운동하기',
            hintStyle: DoitMainTheme.makeGoalHintTextStyle,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          ),
          style: DoitMainTheme.makeGoalUserInputTextStyle,
          maxLines: 1,
        ),
      ],
    );
  }
}
