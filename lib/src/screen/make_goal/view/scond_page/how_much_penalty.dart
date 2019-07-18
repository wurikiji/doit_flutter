import 'package:do_it/src/screen/make_goal/bloc/second_page_goal_bloc.dart';
import 'package:do_it/src/screen/make_goal/model/make_goal_second_page_model.dart';
import 'package:do_it/src/screen/make_goal/view/component/question_scaffold.dart';
import 'package:do_it/src/screen/make_goal/view/component/selectable_chip.dart';
import 'package:easy_stateful_builder/easy_stateful_builder.dart';
import 'package:flutter/material.dart';

const String groupKey = 'HowMuchPenalty';

class HowMuchPenalty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MakeGoalSecondPageBloc _bloc = MakeGoalSecondPageBloc.getBloc(context);
    final int currentPenalty = _bloc.currentState.data.penalty;
    if (EasyStatefulBuilder.getState(groupKey) != null) {
      // 새로 build 될때는 초기화 해야한다.
      try {
        EasyStatefulBuilder.setState(groupKey, (state) {
          state.nextState = <SelectableGradientChip>[];
        });
      } catch (e) {}
    }
    return QuestionScaffold(
      title: '벌금제을 선택해 주세요.(1인당)',
      body: Row(
        children: <Widget>[
          Expanded(
            child: SelectPenaltyButton(
              title: '5,000원',
              value: 5000,
              selected: currentPenalty == 5000,
              onTap: onSelectPenalty,
            ),
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: SelectPenaltyButton(
              title: '10,000원',
              value: 10000,
              selected: currentPenalty == 10000,
              onTap: onSelectPenalty,
            ),
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: SelectPenaltyButton(
              title: '기타',
              value: 0,
              selected: currentPenalty == 0,
              onTap: onSelectPenalty,
            ),
          ),
        ],
      ),
    );
  }

  onSelectPenalty(BuildContext context, List<SelectableGradientChip> value) async {
    MakeGoalSecondPageBloc _bloc = MakeGoalSecondPageBloc.getBloc(context);
    final int penalty = value.isEmpty ? invalidPenalty : value[0].value;
    _bloc.dispatch(
      MakeGoalSecondPageEvent(
        action: MakeGoalSecondPageAction.setPenalty,
        data: penalty,
      ),
    );
  }
}

class SelectPenaltyButton extends StatelessWidget {
  const SelectPenaltyButton({this.onTap, this.title, Key key, this.value, this.selected}) : super(key: key);

  final String title;
  final SelectableChipOnTap onTap;
  final int value;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      child: SelectableGradientChip(
        title: title,
        groupKey: groupKey,
        maxMultiSelectables: 1,
        value: this.value,
        initialSelected: this.selected,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        onTap: onTap,
      ),
    );
  }
}
