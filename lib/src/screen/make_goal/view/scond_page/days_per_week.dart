import 'dart:math';

import 'package:do_it/src/screen/make_goal/bloc/second_page_goal_bloc.dart';
import 'package:do_it/src/screen/make_goal/view/component/selectable_chip.dart';
import 'package:flutter/material.dart';

class DaysPerWeek extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MakeGoalSecondPageBloc _bloc =
        MakeGoalSecondPageBloc.getBloc(context);
    int cycle = _bloc.currentState.data.workCycle;
    cycle = (log(cycle) / log(2)).toInt();
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
              title: '${days + 1}',
              value: days,
              groupKey: 'howManyDaysPerWeek',
              initialSelected: cycle == days,
              maxMultiSelectables: 1,
              onTap: (context, value) {
                MakeGoalSecondPageBloc _bloc =
                    MakeGoalSecondPageBloc.getBloc(context);
                _bloc.dispatch(
                  MakeGoalSecondPageEvent(
                    action: MakeGoalSecondPageAction.setWorkCycle,
                    data: (1 << (days)),
                  ),
                );
              },
              padding: EdgeInsets.symmetric(horizontal: 10.0),
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
