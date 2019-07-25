import 'package:do_it/src/color/doit_theme.dart';
import 'package:do_it/src/screen/make_goal/bloc/second_page_goal_bloc.dart';
import 'package:do_it/src/screen/make_goal/model/make_goal_second_page_model.dart';
import 'package:do_it/src/screen/make_goal/view/component/selectable_chip.dart';
import 'package:easy_stateful_builder/easy_stateful_builder.dart';
import 'package:flutter/material.dart';

class EveryWeekdays extends StatelessWidget {
  final List<String> weekdays = [
    '월',
    '화',
    '수',
    '목',
    '금',
    '토',
    '일',
  ];
  @override
  Widget build(BuildContext context) {
    final MakeGoalSecondPageBloc _bloc = MakeGoalSecondPageBloc.getBloc(context);
    const String counterKey = 'weekdayCounterKey';
    int counter = 0;
    int currentCycle = _bloc.currentState.data.workCycle ?? 0;

    for (int i = 0; i < 7; i++) {
      if ((currentCycle & (1 << i)) != 0) {
        counter++;
      }
    }
    final List<Widget> selectableDays = List.generate(
      13,
      (index) {
        int days = (index ~/ 2);
        if (index % 2 == 1) {
          return SizedBox(width: 8.0);
        }
        return Expanded(
          child: AspectRatio(
            aspectRatio: 1.0,
            child: SelectableGradientChip(
              title: '${weekdays[days]}',
              value: days,
              groupKey: 'everyWeekdays',
              initialSelected: (currentCycle & (1 << days)) != 0,
              maxMultiSelectables: 7,
              onTap: (context, value) {
                MakeGoalSecondPageBloc _bloc = MakeGoalSecondPageBloc.getBloc(context);
                int selectedDays = days;
                int currentCycle = _bloc.currentState.data.workCycle ?? 0;
                currentCycle = (currentCycle ^ (1 << selectedDays));
                _bloc.dispatch(
                  MakeGoalSecondPageEvent(
                    action: MakeGoalSecondPageAction.setWorkCycle,
                    data: currentCycle,
                  ),
                );
                int counter = 0;
                for (int i = 0; i < 7; i++) {
                  if ((currentCycle & (1 << i)) != 0) {
                    counter++;
                  }
                }
                EasyStatefulBuilder.setState(counterKey, (state) {
                  state.nextState = counter;
                });
              },
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
          ),
        );
      },
    );
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              '요일 지정',
              style: DoitMainTheme.makeGoalQuestionTitleStyle,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.check,
                  color: Color(0xff6849ed),
                  size: 14.0,
                ),
                SizedBox(width: 3.0),
                EasyStatefulBuilder(
                  identifier: counterKey,
                  initialValue: counter,
                  keepAlive: false,
                  builder: (context, state) => Text(
                    "주 $state 회로 설정되었습니다.",
                    style: Theme.of(context).textTheme.body1.copyWith(fontSize: 12.0),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 10.0),
        Row(
          children: selectableDays,
        ),
      ],
    );
  }
}
