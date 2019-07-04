import 'package:do_it/src/screen/make_goal/bloc/second_page_goal_bloc.dart';
import 'package:do_it/src/screen/make_goal/view/component/question_scaffold.dart';
import 'package:do_it/src/screen/make_goal/view/component/selectable_chip.dart';
import 'package:do_it/src/screen/make_goal/view/scond_page/days_per_week.dart';
import 'package:do_it/src/screen/make_goal/view/scond_page/every_weekdays.dart';
import 'package:easy_stateful_builder/easy_stateful_builder.dart';
import 'package:flutter/material.dart';

class HowManyTimes extends StatefulWidget {
  @override
  _HowManyTimesState createState() => _HowManyTimesState();
}

enum _AdditionalQuestion { daysPerWeek, everyWeekDays, none }

class _HowManyTimesState extends State<HowManyTimes>
    with SingleTickerProviderStateMixin {
  _AdditionalQuestion additionalQuestionIndex = _AdditionalQuestion.none;
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
    MakeGoalSecondPageBloc _bloc = MakeGoalSecondPageBloc.getBloc(context);
    int cycle = _bloc.currentState.data.workCycle;
    if ((cycle ?? 0) > 0 && cycle < (1 << 10)) {
      additionalQuestionIndex = _AdditionalQuestion.daysPerWeek;
    } else if ((cycle ?? 0) > (1 << 8) && cycle < (1 << 20)) {
      additionalQuestionIndex = _AdditionalQuestion.everyWeekDays;
    } else if (cycle == null) {
      cycle = 1 << 23;
    }
    print("Cycle: $cycle");
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
                  value: _AdditionalQuestion.daysPerWeek,
                  selected: cycle < (1 << 10) && cycle > 0,
                  onTap: (context, value) {
                    showAdditionalQuestion(value);
                  },
                ),
              ),
              SizedBox(width: 12.0),
              Expanded(
                child: SelectHowOftenButton(
                  groupKey: groupKey,
                  title: '요일별',
                  selected: cycle < (1 << 20) && cycle > (1 << 8),
                  value: _AdditionalQuestion.everyWeekDays,
                  onTap: (context, value) {
                    showAdditionalQuestion(value);
                  },
                ),
              ),
              SizedBox(width: 12.0),
              Expanded(
                child: SelectHowOftenButton(
                  groupKey: groupKey,
                  title: '제한 없음',
                  value: _AdditionalQuestion.none,
                  selected: cycle == 0,
                  onTap: (context, value) {
                    showAdditionalQuestion(value);
                  },
                ),
              ),
            ],
          ),
          EasyStatefulBuilder(
            identifier: 'additionalQuestion',
            keepAlive: false,
            initialValue: _AdditionalQuestion.none,
            builder: (context, state) {
              if (additionalQuestionIndex != _AdditionalQuestion.none) {
                animationController.reset();
                animationController.forward();
                return SizeTransition(
                  sizeFactor: animationController,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 10.0),
                      additionalQuestionIndex == _AdditionalQuestion.daysPerWeek
                          ? DaysPerWeek()
                          : EveryWeekdays(),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }

  showAdditionalQuestion(List<SelectableGradientChip> value) async {
    EasyStatefulBuilder.setState('additionalQuestion', (state) {
      if (value.isEmpty) {
        additionalQuestionIndex = _AdditionalQuestion.none;
      } else {
        MakeGoalSecondPageBloc _bloc = MakeGoalSecondPageBloc.getBloc(context);
        _bloc.dispatch(
          MakeGoalSecondPageEvent(
            action: MakeGoalSecondPageAction.setWorkCycle,
            data: value[0].value == _AdditionalQuestion.none ? 0 : 1 << 31,
          ),
        );
        print("${value[0].value}");
        additionalQuestionIndex = value[0].value;
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
    this.selected,
  }) : super(key: key);

  final String groupKey;
  final String title;
  final SelectableChipOnTap onTap;
  final value;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      child: SelectableGradientChip(
        groupKey: groupKey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        title: title,
        initialSelected: this.selected,
        value: value,
        onTap: onTap,
      ),
    );
  }
}
