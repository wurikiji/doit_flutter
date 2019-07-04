import 'dart:math';

import 'package:do_it/src/screen/make_goal/bloc/second_page_goal_bloc.dart';
import 'package:do_it/src/screen/make_goal/view/component/selectable_chip.dart';
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
    final MakeGoalSecondPageBloc _bloc =
        MakeGoalSecondPageBloc.getBloc(context);
    int currentCycle = _bloc.currentState.data.workCycle ?? 0;
    if (currentCycle < (1 << 10) || currentCycle > (1 << 19)) {
      currentCycle = 0;
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
              initialSelected: (currentCycle & (1 << days + 10)) != 0,
              maxMultiSelectables: 7,
              onTap: (context, value) {
                MakeGoalSecondPageBloc _bloc =
                    MakeGoalSecondPageBloc.getBloc(context);
                int currentCycle = _bloc.currentState.data.workCycle ?? 0;
                if (currentCycle < (1 << 10) || currentCycle > (1 << 19)) {
                  currentCycle = 0;
                }
                _bloc.dispatch(
                  MakeGoalSecondPageEvent(
                    action: MakeGoalSecondPageAction.setWorkCycle,
                    data: (currentCycle | (1 << (days + 10))),
                  ),
                );
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
    return Row(
      children: selectableDays,
    );
  }
}
