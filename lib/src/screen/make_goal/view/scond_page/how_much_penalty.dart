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
            child: SelectPenaltyButton(
              title: '5,000원',
              onTap: (context, value) {},
            ),
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: SelectPenaltyButton(
              title: '10,000원',
              onTap: (context, value) {},
            ),
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: SelectPenaltyButton(
              title: '제한 없음',
              onTap: (context, value) {},
            ),
          ),
        ],
      ),
    );
  }
}

class SelectPenaltyButton extends StatelessWidget {
  const SelectPenaltyButton({
    this.onTap,
    this.title,
    Key key,
  }) : super(key: key);

  final String title;
  final SelectableChipOnTap onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      child: SelectableGradientChip(
        title: title,
        groupKey: 'HowMuchPenalty',
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        onTap: onTap,
      ),
    );
  }
}
