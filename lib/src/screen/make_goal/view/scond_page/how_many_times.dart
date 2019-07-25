import 'package:do_it/src/screen/make_goal/bloc/second_page_goal_bloc.dart';
import 'package:do_it/src/screen/make_goal/model/make_goal_second_page_model.dart';
import 'package:do_it/src/screen/make_goal/view/component/question_scaffold.dart';
import 'package:do_it/src/screen/make_goal/view/component/selectable_chip.dart';
import 'package:do_it/src/screen/make_goal/view/scond_page/days_per_week.dart';
import 'package:do_it/src/screen/make_goal/view/scond_page/every_weekdays.dart';
import 'package:do_it/src/service/api/goal_service.dart';
import 'package:easy_stateful_builder/easy_stateful_builder.dart';
import 'package:flutter/material.dart';

class HowManyTimes extends StatefulWidget {
  @override
  _HowManyTimesState createState() => _HowManyTimesState();
}

enum _AdditionalQuestion { daysPerWeek, everyWeekDays, none }

class _HowManyTimesState extends State<HowManyTimes> with SingleTickerProviderStateMixin {
  DoitGoalRepeatType additionalQuestionIndex = DoitGoalRepeatType.invalid;
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
    MakeGoalSecondPageBloc _bloc = MakeGoalSecondPageBloc.getBloc(context);
    DoitGoalRepeatType repeatType = _bloc.currentState.data.repeatType;
    additionalQuestionIndex = repeatType;
    print(repeatType);
    return QuestionScaffold(
      title: '어떻게 진행할까요?',
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: SelectHowOftenButton(
                  groupKey: groupKey,
                  title: '매일',
                  value: DoitGoalRepeatType.everyDay,
                  selected: repeatType == DoitGoalRepeatType.everyDay,
                  onTap: (context, value) {
                    showAdditionalQuestion(value);
                  },
                ),
              ),
              SizedBox(width: 12.0),
              Expanded(
                child: SelectHowOftenButton(
                  groupKey: groupKey,
                  title: '주별 횟수',
                  value: DoitGoalRepeatType.perWeek,
                  selected: repeatType == DoitGoalRepeatType.perWeek,
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
                  selected: repeatType == DoitGoalRepeatType.perDay,
                  value: DoitGoalRepeatType.perDay,
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
            initialValue: DoitGoalRepeatType.invalid,
            builder: (context, state) {
              if (additionalQuestionIndex != DoitGoalRepeatType.invalid &&
                  additionalQuestionIndex != DoitGoalRepeatType.everyDay) {
                animationController.reset();
                animationController.forward();
                return SizeTransition(
                  sizeFactor: animationController,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20.0),
                      additionalQuestionIndex == DoitGoalRepeatType.perWeek ? DaysPerWeek() : EveryWeekdays(),
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
    MakeGoalSecondPageBloc _bloc = MakeGoalSecondPageBloc.getBloc(context);
    if (value.isEmpty) {
      additionalQuestionIndex = DoitGoalRepeatType.invalid;
      _bloc.dispatch(
        MakeGoalSecondPageEvent(
          action: MakeGoalSecondPageAction.setWorkType,
          data: additionalQuestionIndex,
        ),
      );
    } else {
      additionalQuestionIndex = value[0].value;
      _bloc.dispatch(
        MakeGoalSecondPageEvent(
          action: MakeGoalSecondPageAction.setWorkType,
          data: additionalQuestionIndex,
        ),
      );
    }
    EasyStatefulBuilder.setState('additionalQuestion', (state) {});
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
