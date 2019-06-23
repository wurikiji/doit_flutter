import 'package:do_it/src/screen/make_goal/view/component/question_scaffold.dart';
import 'package:do_it/src/screen/make_goal/view/component/selectable_chip.dart';
import 'package:flutter/material.dart';

class HowMuchPenalty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return QuestionScaffold(
      title: '벌금제를 원하면 선택해 주세요.(1인당)',
      body: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 40.0,
              child: SelectableGradientChip(
                title: '5,000원',
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
            ),
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: Container(
              height: 40.0,
              child: SelectableGradientChip(
                title: '10,000원',
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
            ),
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: Container(
              height: 40.0,
              child: SelectableGradientChip(
                title: '선택안함',
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
