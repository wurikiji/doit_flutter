import 'dart:ui';

import 'package:do_it/src/color/doit_theme.dart';
import 'package:do_it/src/screen/make_goal/bloc/second_page_goal_bloc.dart';
import 'package:do_it/src/screen/make_goal/model/make_goal_second_page_model.dart';
import 'package:do_it/src/screen/make_goal/view/component/selectable_chip.dart';
import 'package:easy_stateful_builder/easy_stateful_builder.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const String groupKey = 'HowMuchPenalty';
const String penaltyKey = 'customPenalty';

class HowMuchPenalty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MakeGoalSecondPageBloc _bloc = MakeGoalSecondPageBloc.getBloc(context);
    final int currentPenalty = _bloc.currentState.data.penalty;
    NumberFormat formatter = NumberFormat('#,###');
    if (EasyStatefulBuilder.getState(groupKey) != null) {
      // 새로 build 될때는 초기화 해야한다.
      try {
        EasyStatefulBuilder.setState(groupKey, (state) {
          state.nextState = <SelectableGradientChip>[];
        });
      } catch (e) {}
    }
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '벌금을 선택해 주세요.(인당)',
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
                  identifier: penaltyKey,
                  initialValue: 0,
                  keepAlive: false,
                  builder: (context, state) => Text(
                    state == invalidPenalty ? '선택해주세요.' : "벌금 ${formatter.format(state)} 원",
                    style: Theme.of(context).textTheme.body1.copyWith(fontSize: 12.0),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 10.0),
        Row(
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
      ],
    );
  }

  onSelectPenalty(BuildContext context, List<SelectableGradientChip> value) async {
    MakeGoalSecondPageBloc _bloc = MakeGoalSecondPageBloc.getBloc(context);
    int penalty = value.isEmpty ? invalidPenalty : value[0].value;
    if (penalty == 0) {
      penalty = await showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.black.withAlpha(0x99),
        barrierLabel: 'Set penalty',
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return child;
        },
        transitionDuration: Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondAnimation) {
          return DoitSetPenalty();
        },
      );
      penalty ??= 0;
    }
    _bloc.dispatch(
      MakeGoalSecondPageEvent(
        action: MakeGoalSecondPageAction.setPenalty,
        data: penalty,
      ),
    );
    EasyStatefulBuilder.setState(penaltyKey, (state) {
      state.nextState = penalty;
    });
  }
}

class DoitSetPenalty extends StatefulWidget {
  const DoitSetPenalty({
    Key key,
  }) : super(key: key);

  @override
  _DoitSetPenaltyState createState() => _DoitSetPenaltyState();
}

class _DoitSetPenaltyState extends State<DoitSetPenalty> {
  TextEditingController _textEditingController = TextEditingController(
    text: '0',
  );

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 27.0),
            height: 236.0,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              color: Color(0xff222222),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 54.0),
                Text(
                  '원하는 벌금을 입력하세요.',
                  style: TextStyle(
                    fontFamily: 'SpoqaHanSans',
                    fontSize: 14.0,
                  ),
                ),
                SizedBox(height: 20.0),
                SizedBox(
                  width: 180.0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '금액',
                        style: const TextStyle(
                          color: const Color(0xffffffff),
                          fontWeight: FontWeight.w700,
                          fontFamily: "SpoqaHanSans",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0,
                        ),
                      ),
                      SizedBox(width: 6.0),
                      Expanded(
                        child: TextField(
                          controller: _textEditingController,
                          textAlign: TextAlign.center,
                          autofocus: true,
                          cursorColor: Color(0xff979797),
                          keyboardType: TextInputType.number,
                          textAlignVertical: TextAlignVertical.center,
                          maxLength: 7,
                          decoration: null,
                          style: const TextStyle(
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.normal,
                            fontFamily: "SpoqaHanSans",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0,
                          ),
                          onChanged: (text) {
                            NumberFormat formatter = NumberFormat('#,###');
                            setState(() {
                              _textEditingController.text = formatter.format(text);
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 6.0),
                      Text(
                        '원',
                        style: const TextStyle(
                          color: const Color(0xffffffff),
                          fontWeight: FontWeight.w700,
                          fontFamily: "SpoqaHanSans",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4.0),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      width: 32.0,
                    ),
                    Container(
                      width: 145.0,
                      height: 1.0,
                      color: Color(0xff979797),
                    ),
                  ],
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(int.parse(_textEditingController.text));
                  },
                  child: Container(
                    height: 50.0,
                    width: 150.0,
                    decoration: ShapeDecoration(
                      shape: StadiumBorder(),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xff5188fa),
                          Color(0xff7526e6),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '확인',
                        style: TextStyle(
                          fontFamily: 'SpoqaHanSans',
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40.0),
              ],
            ),
          ),
        ),
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
