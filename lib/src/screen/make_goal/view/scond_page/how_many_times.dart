import 'package:do_it/src/screen/make_goal/view/component/question_scaffold.dart';
import 'package:do_it/src/screen/make_goal/view/component/selectable_chip.dart';
import 'package:flutter/material.dart';

class HowManyTimes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String groupKey = 'howManyTimes';
    final String title = '주별 횟수';
    final Function onTap = (context, value) {};
    return QuestionScaffold(
      title: '어떻게 진행할까요?',
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: SelectHowOftenButton(
                  groupKey: groupKey,
                  title: '주별 횟수',
                  onTap: onTap,
                ),
              ),
              SizedBox(width: 12.0),
              Expanded(
                child: SelectHowOftenButton(
                  groupKey: groupKey,
                  title: '요일별',
                  onTap: (context, value) {},
                ),
              ),
              SizedBox(width: 12.0),
              Expanded(
                child: SelectHowOftenButton(
                  groupKey: groupKey,
                  title: '제한 없음',
                  onTap: (context, value) {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SelectHowOftenButton extends StatelessWidget {
  const SelectHowOftenButton({
    Key key,
    @required this.groupKey,
    @required this.title,
    @required this.onTap,
  }) : super(key: key);

  final String groupKey;
  final String title;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      child: SelectableGradientChip(
        groupKey: groupKey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        title: title,
        onTap: onTap,
      ),
    );
  }
}
