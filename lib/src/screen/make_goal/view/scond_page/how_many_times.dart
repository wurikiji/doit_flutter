import 'package:do_it/src/screen/make_goal/view/component/question_scaffold.dart';
import 'package:do_it/src/screen/make_goal/view/component/selectable_chip.dart';
import 'package:flutter/material.dart';

class HowManyTimes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return QuestionScaffold(
      title: '어떻게 진행할까요?',
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 40.0,
                  child: SelectableGradientChip(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0)),
                    title: '주별 횟수',
                  ),
                ),
              ),
              SizedBox(width: 12.0),
              Expanded(
                child: Container(
                  height: 40.0,
                  child: SelectableGradientChip(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0)),
                    title: '요일별',
                  ),
                ),
              ),
              SizedBox(width: 12.0),
              Expanded(
                child: Container(
                  height: 40.0,
                  child: SelectableGradientChip(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0)),
                    title: '제한 없음',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
