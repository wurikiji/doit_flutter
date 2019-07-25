import 'package:do_it/src/color/doit_theme.dart';
import 'package:do_it/src/screen/make_goal/bloc/second_page_goal_bloc.dart';
import 'package:do_it/src/screen/make_goal/model/make_goal_second_page_model.dart';
import 'package:do_it/src/screen/make_goal/view/component/selectable_chip.dart';
import 'package:easy_stateful_builder/easy_stateful_builder.dart';
import 'package:flutter/material.dart';

class DaysPerWeek extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MakeGoalSecondPageBloc _bloc = MakeGoalSecondPageBloc.getBloc(context);
    const String counterKey = 'cycleCounterKey';
    const String groupKey = 'howManyDaysPerWeek';
    int cycle = _bloc.currentState.data.workCycle ?? 0;
    final List<Widget> selectableDays = List.generate(
      13,
      (index) {
        int days = (index ~/ 2) + 1;
        if (index % 2 == 1) {
          return SizedBox(width: 8.0);
        }
        return Expanded(
          child: AspectRatio(
            aspectRatio: 1.0,
            child: SelectableGradientChip(
              title: '$days',
              value: days,
              groupKey: groupKey,
              initialSelected: cycle == days,
              maxMultiSelectables: 1,
              onTap: (context, value) {
                MakeGoalSecondPageBloc _bloc = MakeGoalSecondPageBloc.getBloc(context);
                int days = value.isEmpty ? 0 : value[0].value;
                _bloc.dispatch(
                  MakeGoalSecondPageEvent(
                    action: MakeGoalSecondPageAction.setWorkCycle,
                    data: days,
                  ),
                );
                EasyStatefulBuilder.setState(counterKey, (state) {
                  state.nextState = days;
                });
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
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              '주별 횟수 지정',
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
                  initialValue: cycle,
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
