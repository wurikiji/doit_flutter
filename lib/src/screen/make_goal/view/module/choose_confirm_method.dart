import 'package:do_it/src/color/doit_theme.dart';
import 'package:do_it/src/screen/make_goal/view/component/question_scaffold.dart';
import 'package:do_it/src/screen/make_goal/view/component/selectable_chip.dart';
import 'package:easy_stateful_builder/easy_stateful_builder.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const willUseTimer = ConfirmMethod(
  title: '타이머 사용',
  icon: FontAwesomeIcons.stopwatch,
);

class ConfirmMethod {
  const ConfirmMethod({
    this.icon,
    @required this.title,
  });
  final String title;
  final IconData icon;
}

class ChooseConfirmMethod extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ConfirmMethod method = willUseTimer;
    final String chipKey = 'confirm' + method.title + 'Icon';
    final String groupKey = "willUseTimerQuestion";

    return QuestionScaffold(
      title: '타이머 사용여부를 선택해주세요.',
      body: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          WillUseTimerQuestionWidget(
              method: method, groupKey: groupKey, chipKey: chipKey),
          SizedBox(width: 14.0),
          ConfirmMethodsNotice(),
        ],
      ),
    );
  }
}

class ConfirmMethodsNotice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 14.0,
                height: 14.0,
                decoration: ShapeDecoration(
                  shape: CircleBorder(),
                  gradient: LinearGradient(colors: [
                    Color(0xff4d90fb),
                    Color(0xff771de4),
                  ]),
                ),
                child: Center(
                  child: Text(
                    "!",
                    style: DoitMainTheme.makeGoalQuestionTitleStyle.copyWith(
                      fontSize: 11.0,
                      height: 0.9,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 4.0),
              Text(
                "알려드려요",
                style: DoitMainTheme.makeGoalQuestionTitleStyle
                    .copyWith(fontSize: 12.0),
              ),
            ],
          ),
          Text(
            "기본 인증방식은 글+사진 입니다.",
            style: DoitMainTheme.makeGoalUserInputTextStyle
                .copyWith(fontSize: 10.0),
          ),
        ],
      ),
    );
  }
}

class WillUseTimerQuestionWidget extends StatelessWidget {
  const WillUseTimerQuestionWidget({
    Key key,
    @required this.method,
    @required this.groupKey,
    @required this.chipKey,
  }) : super(key: key);

  final ConfirmMethod method;
  final String groupKey;
  final String chipKey;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 40.0,
        child: SelectableGradientChip(
          title: method.title,
          value: 0,
          groupKey: groupKey,
          maxMultiSelectables: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          icon: EasyStatefulBuilder(
            identifier: chipKey,
            keepAlive: false,
            initialValue: false,
            builder: (context, selected) {
              return Icon(
                method.icon,
                size: 18.0,
                color: selected ? Color(0xffffffff) : Color(0x66ffffff),
              );
            },
          ),
          onTap: (context, _) {
            /// 아이콘 색 변경을 위한 setState
            EasyStatefulBuilder.setState(
              chipKey,
              (state) {
                state.nextState = !state.currentState;
              },
            );
          },
        ),
      ),
    );
  }
}
