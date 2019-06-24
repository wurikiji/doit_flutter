import 'package:do_it/src/screen/make_goal/view/component/question_scaffold.dart';
import 'package:do_it/src/screen/make_goal/view/component/selectable_chip.dart';
import 'package:do_it/src/screen/make_goal/view/scond_page/days_per_week.dart';
import 'package:do_it/src/screen/make_goal/view/scond_page/every_weekdays.dart';
import 'package:flutter/material.dart';

class HowManyTimes extends StatefulWidget {
  @override
  _HowManyTimesState createState() => _HowManyTimesState();
}

enum AdditionalQuestion { daysPerWeek, everyWeekDays, none }

class _HowManyTimesState extends State<HowManyTimes>
    with SingleTickerProviderStateMixin {
  AdditionalQuestion additionalQuestionIndex = AdditionalQuestion.none;
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

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
                  value: AdditionalQuestion.daysPerWeek,
                  onTap: (context, value) async {
                    showAdditionalQuestion(value);
                  },
                ),
              ),
              SizedBox(width: 12.0),
              Expanded(
                child: SelectHowOftenButton(
                  groupKey: groupKey,
                  title: '요일별',
                  value: AdditionalQuestion.everyWeekDays,
                  onTap: (context, value) async {
                    showAdditionalQuestion(value);
                  },
                ),
              ),
              SizedBox(width: 12.0),
              Expanded(
                child: SelectHowOftenButton(
                  groupKey: groupKey,
                  title: '제한 없음',
                  value: 1,
                  onTap: (context, value) async {
                    showAdditionalQuestion([]);
                  },
                ),
              ),
            ],
          ),
          if (additionalQuestionIndex != AdditionalQuestion.none)
            SizeTransition(
              sizeFactor: animationController,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10.0),
                  additionalQuestionIndex == AdditionalQuestion.daysPerWeek
                      ? DaysPerWeek()
                      : EveryWeekdays(),
                ],
              ),
            ),
        ],
      ),
    );
  }

  showAdditionalQuestion(List<SelectableGradientChip> value) async {
    setState(() {
      if (value.isEmpty) {
        additionalQuestionIndex = AdditionalQuestion.none;
      } else {
        additionalQuestionIndex = value[0].value;
        animationController.reset();
        animationController.forward();
      }
    });
  }
}

class SelectHowOftenButton extends StatelessWidget {
  const SelectHowOftenButton({
    Key key,
    @required this.groupKey,
    @required this.title,
    @required this.onTap,
    this.value,
  }) : super(key: key);

  final String groupKey;
  final String title;
  final SelectableChipOnTap onTap;
  final value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      child: SelectableGradientChip(
        groupKey: groupKey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        title: title,
        value: value,
        onTap: onTap,
      ),
    );
  }
}
